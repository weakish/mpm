0.6.1 # Released on 2015-03

- Remove accents in generated random password.

0.6.0 # Released on 2014-11

- No temporary decrypted record file on disk.

0.5 # Released on 2013-02

- quoted here-documents to avoid shell expansion.
- improve password strength
- encrypt the record file via gpg (again)

0.4 # Released on 2012-02

- improve password strength

0.3 # Released on 2011-04

- Use plain text record file again:
 Encryption, if needed, can be done at file system level
 separately, for example, a fuse file system
- Use space instead of comma to separate fields in record
 file, since comma is allowed in URL
- addRecord(): remove option '-e' from echo for sh compatibility

0.2 # Released on 2009-08

- Use gpg to encrypt the record file

semver=0.1 # Released on 2009-08
