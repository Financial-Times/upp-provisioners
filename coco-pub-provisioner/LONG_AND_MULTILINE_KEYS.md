Setting multi-line or large keys in the vault
===============================================

Problem:

1. systemd does not support lines longer than 2048 characters in unit files
2. can't have multi-line values in cloudconfig, as it will break YAML syntax

Workaround:

1. base64 encode the key (remove new lines)
2. split it in several pieces, with reasonable length (~1500)
3. set the pieces as different keys in the vault
4. set the pieces as different keys in etcd in cloudconfig
5. concatenate the keys and base64 decode it in the unit files

e.g.
 
    ENCODED=`cat ~/.ssh/id_rsa | base64 | tr -d "\n"`
    LENGTH=`echo ${#ENCODED}`
    FIRST_PART=${ENCODED::LENGTH/2}
    SECOND_PART=${ENCODED:LENGTH/2}
    #set two keys in vault for FIRST_PART and SECOND_PART

