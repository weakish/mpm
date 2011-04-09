#!/bin/sh

# (c) 2009-2011 Jakukyo Friel <weakish@gmail.com>
# under GPL v2

## Minalistic password manager 

# I use a simple plain text file to store password for websites.

# The syntax is very simple.  It records a short name, site url, password
# and (optional) notes.  Usually I use the same username and email address,
# so no need to record them again and again. (If I do use a different username
# or email address, they go into the optional notes field.)

#    example http://example.org password additional notes

# Versions

semver=0.3.0 # Released on 2011-04
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
mpmrc=$HOME/.mpmrc

searchRecord() {
local pattern=$1
grep -E "$pattern" $mpmrc
}

# By default, we use length 10, about as secure as a 59bit key
# ( log((26*2+10)**10)/log(2) ).  Well, distribute.net has cracked a 
# AES 64bit key, so you may use a longer password.
genRandomPass() {
local len=$1
dd if=/dev/urandom count=1 2>/dev/null |
uuencode -m - |
head -n 2 | tail -n 1 | cut -c -${len:-10} |
sed -e 's/[^[:alnum:]]//g'
}



addRecord() {
local pw=`mpm -g`
local site=$1
local url=$2
shift 2
echo "$site $url $pw $*" >> $mpmrc
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
~/.mpmrc    record file
END
}


case $1 in
    -V) echo 'mpm Minimalistic password manager' $semver;;
    -h) printHelp;;
    -g) genRandomPass $2;;
    -s) searchRecord $2;;
    *) addRecord $*;;
esac

