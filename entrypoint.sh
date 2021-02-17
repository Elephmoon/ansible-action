#!/bin/sh

set -e

# Evaluate keyfilevaultpass
export KEYFILEVAULTPASS=
if [ ! -z "$INPUT_KEYFILEVAULTPASS" ]
then
  echo "Using \$INPUT_KEYFILE_VAULT_PASS to decrypt and access vault."
  mkdir -p ~/.ssh
  echo "${INPUT_KEYFILEVAULTPASS}" > ~/.ssh/vault_key
  export KEYFILEVAULTPASS="--vault-password-file ~/.ssh/vault_key"
else
  echo "\$INPUT_KEYFILEVAULTPASS not set. Won't be able to decrypt any encrypted file."
fi

# Evaluate keyfile
export KEYFILE=
if [ ! -z "$INPUT_KEYFILE" ]
then
  echo "\$INPUT_KEYFILE is set. Will use ssh keyfile for host connections."
  if [ ! -z "$KEYFILEVAULTPASS" ]
  then
    echo "Using \$INPUT_KEYFILE_VAULT_PASS to decrypt keyfile."
    ansible-vault decrypt ${INPUT_KEYFILE} ${KEYFILEVAULTPASS}
  fi
  export KEYFILE="--key-file ${INPUT_KEYFILE}"
else
  echo "\$INPUT_KEYFILE not set. You'll most probably only be able to work on localhost."
fi

# Evaluate verbosity
export VERBOSITY=
if [ -z "$INPUT_VERBOSITY" ]
then
  echo "\$INPUT_VERBOSITY not set. Will use standard verbosity."
else
  echo "\$INPUT_VERBOSITY is set. Will use verbosity level $INPUT_VERBOSITY."
  export VERBOSITY="-$INPUT_VERBOSITY"
fi

# Evaluate inventory file
export INVENTORY=
if [ -z "$INPUT_INVENTORYFILE" ]
then
  echo "\$INPUT_INVENTORYFILE not set. Won't use any inventory option at playbook call."
else
  echo "\$INPUT_INVENTORYFILE is set. Will use ${INPUT_INVENTORYFILE} as inventory file."
  export INVENTORY="-i ${INPUT_INVENTORYFILE}"
  cat ansible/dev/hosts.yml
fi

# Evaluate requirements.
export REQUIREMENTS=
if [ -z "$INPUT_REQUIREMENTSFILE" ]
then
  echo "\$INPUT_REQUIREMENTSFILE not set. Won't install any additional external roles."
else
  REQUIREMENTS=$INPUT_REQUIREMENTSFILE

  ansible-galaxy install --force -r ${REQUIREMENTS} ${VERBOSITY}
fi

# Evaluate extra vars file
export EXTRAFILE=
if [ -z "$INPUT_EXTRAFILE" ]
then
  echo "\$INPUT_EXTRAFILE not set. Won't inject any extra vars file."
else
  echo "\$INPUT_EXTRAFILE is set. Will inject ${INPUT_EXTRAFILE} as extra vars file."
  export EXTRAFILE="--extra-vars @${INPUT_EXTRAFILE}"
fi

echo "going to execute: "
echo ansible-playbook ${INPUT_PLAYBOOKNAME} ${INVENTORY} ${EXTRAFILE} ${INPUT_EXTRAVARS} ${KEYFILE} ${VERBOSITY}
ansible-playbook ${INVENTORY} ${EXTRAFILE} ${INPUT_EXTRAVARS} ${VERBOSITY} ${INPUT_PLAYBOOKNAME}
