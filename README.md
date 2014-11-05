# mpm

Minimalistic command line password manager

## Installation

Copy `mpm.sh` to your `$PATH`.

## Usage

See `mpm -h`:

```
; mpm -h
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
```

## Contribute

Open a issue or send a pull request at https://github.com/weakish/mpm
