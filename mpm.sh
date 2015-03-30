#!/bin/sh

# (c) 2009-2013 Jakukyo Friel <weakish@gmail.com>
# under GPL v2

## Minimalistic password manager

# I use a simple plain text file to store password for websites.

# The syntax is very simple.  It records a short name, site url, password
# and (optional) notes.  Usually I use the same username and email address,
# so no need to record them again and again. (If I do use a different username
# or email address, they go into the optional notes field.)

#    example http://example.org password additional notes

# Requires Python 3

# Versions

semver=0.6.1

# The record file
mpmrc=$HOME/.mpmrc.gpg


decryptRecord() {
  gpg --quiet --yes --decrypt $1
}

encryptRecord() {
  gpg --quiet --yes --output $mpmrc -r `whoami` --encrypt
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
# And it roughly needs 6 billions USD to break.
generateRandomPass() {
python3 <<'END'
import random
import unicodedata
def strip_accents(s):
  return ''.join(c for c in unicodedata.normalize('NFD', s)
    if not unicodedata.combining(c))
wordlist = open('/usr/share/dict/words').readlines()
pick = lambda : random.choice(wordlist)
for i in range(5): print(pick().replace('\'', '').strip(), end='')
END
}

addRecord() {
local pw=`mpm -g` # Not generateRandomPass since it is in Python.
local site=$1
local url=$2
shift 2
{ decryptRecord $mpmrc;
echo "$site $url $pw $*"; } |
encryptRecord
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
    -g) generateRandomPass $2;;
    -s) searchRecord $2;;
    *) addRecord $*;;
esac
