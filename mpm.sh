#!/bin/sh

# (c) 2009-2013 Jakukyo Friel <weakish@gmail.com>
# under GPL v2

## Minalistic password manager 

# I use a simple plain text file to store password for websites.

# The syntax is very simple.  It records a short name, site url, password
# and (optional) notes.  Usually I use the same username and email address,
# so no need to record them again and again. (If I do use a different username
# or email address, they go into the optional notes field.)

#    example http://example.org password additional notes

# Requires Python3

# Versions

semver=0.5 # Released on 2013-02
# - quoted here-documents to avoid shell expansion.
# - improve password strength
# - encrypt the record file via gpg (again)

# semver=0.4 # Released on 2012-02
# improve password strength

# semver=0.3 # Released on 2011-04
# - Use plain text record file again:
#   Encryption, if needed, can be done at file system level
#   seperately, for example, a fuse file system
# - Use space instead of comma to seperate fields in record
#   file, since comma is allowed in URL
# - addRecord(): remove option '-e' from echo for sh compatibility

# semver=0.2 # Released on 2009-08
# - Use gpg to encrypt the record file

# semver=0.1 # Released on 2009-08


# The record file
mpmrc=$HOME/.mpmrc.gpg


decryptRecord() {
  gpg --quiet --yes -d $1
}

encryptRecord() {
  gpg --quiet --yes --output $mpmrc -r `whoami` -e $1 &&
  shred $1
}

searchRecord() {
  local pattern=$1
  decryptRecord $mpmrc |
  grep -E "$pattern"
}

# inspired by http://xkcd.com/936/
# But I use 5 words instead of 4, since 5 words will achieve an entropy of:
#     log(99171)/log(2)*5 = 82.988
# This is enough.
# NIST recommends 80-bits for the most secure passwords.
genRandomPass() {
python3 <<'END'
import random
wordlist = open('/usr/share/dict/words').readlines()
pick = lambda : random.choice(wordlist)
for i in range(5): print(pick().replace('\'', '').strip(), end='')
END
}


addRecord() {
local pw=`mpm -g`
local site=$1
local url=$2
shift 2
decryptRecord $mpmrc > $mpmrc.nc &&
echo "$site $url $pw $*" >> $mpmrc.nc &&
encryptRecord $mpmrc.nc &&
echo $pw
}



printHelp() {
cat <<END
mpm site url [note ...]
Add a new password record with generated random password.
And print the record to stdout.

mpm [option]

options:
-V            show version
-h            show this help
-g N          generate a random password with length N (default 10)
-s pattern    search records

files: 
~/.mpmrc.gpg    record file encrypted via gpg with your public key
END
}


case $1 in
    -V) echo 'mpm Minimalistic password manager' $semver;;
    -h) printHelp;;
    -g) genRandomPass $2;;
    -s) searchRecord $2;;
    *) addRecord $*;;
esac

