#!/bin/bash
set -eu

while IFS=, read -r filename email passphrase
do
  if [ -n ${filename} ] && [ -n ${email} ] && [ -n ${passphrase} ]; then
    docker-compose run -d ssh ssh-keygen -t rsa -b 4096 -N ${passphrase} -C ${email} -f /data/${filename}
    docker-compose run -d ssh /bin/sh -c "echo ${passphrase} > /data/${filename}.passphrase"
    docker-compose run -d ssh puttygen "/data/${filename}" -b 4096 -C "${email}" -O private -o "/data/${filename}.ppk" --old-passphrase "/data/${filename}.passphrase" --new-passphrase "/data/${filename}.passphrase"
    docker-compose run -d ssh /bin/sh -c "rm -f /data/${filename}.passphrase"
  fi
done

# PuTTYgen: key generator and converter for the PuTTY tools
# Release 0.73
# Usage: puttygen ( keyfile | -t type [ -b bits ] )
#                 [ -C comment ] [ -P ] [ -q ]
#                 [ -o output-keyfile ] [ -O type | -l | -L | -p ]
#   -t    specify key type when generating (ed25519, ecdsa, rsa, dsa, rsa1)
#   -b    specify number of bits when generating key
#   -C    change or specify key comment
#   -P    change key passphrase
#   -q    quiet: do not display progress bar
#   -O    specify output type:
#            private             output PuTTY private key format
#            private-openssh     export OpenSSH private key
#            private-openssh-new export OpenSSH private key (force new format)
#            private-sshcom      export ssh.com private key
#            public              RFC 4716 / ssh.com public key
#            public-openssh      OpenSSH public key
#            fingerprint         output the key fingerprint
#   -o    specify output file
#   -l    equivalent to `-O fingerprint'
#   -L    equivalent to `-O public-openssh'
#   -p    equivalent to `-O public'
#   --old-passphrase file
#         specify file containing old key passphrase
#   --new-passphrase file
#         specify file containing new key passphrase
#   --random-device device
#         specify device to read entropy from (e.g. /dev/urandom)
