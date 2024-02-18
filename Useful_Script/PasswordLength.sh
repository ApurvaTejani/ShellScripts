#!/bin/bash
<<COMMENT
LENGTH=48

while getopts vl:s OPTION
do
  if [[ "${OPTION}" -eq v ]];
   then
      VERBOSE='true'
      echo'verbose mode on'
   elif [[ "${OPTION}" -eq l ]];
    then
       LENGTH="${OPTARG}"
    elif [[ "${OPTION}" -eq s ]];
    then 
       USE_SP='true'
    else
       echo'Invalid Option'
    exit 1
  fi
done
COMMENT
usage() {
  echo "Usage: ${0} [-vs] [-l LENGTH]" >&2
  echo 'Generate a random password.' >&2
  echo '  -l LENGTH  Specify the password length.' >&2
  echo '  -s         Append a special character to the password.' >&2
  echo '  -v         Increase verbosity.' >&2
  exit 1
}

log() {
  local MESSAGE="${@}"
  if [[ "${VERBOSE}" = 'true' ]]
  then
    echo "${MESSAGE}"
  fi
}
LENGTH=48

while getopts "vl:s" OPTION
do
  if [[ "${OPTION}" == "v" ]]; then
    VERBOSE='true'
    echo 'verbose mode on'
  elif [[ "${OPTION}" == "l" ]]; then
    LENGTH="${OPTARG}"
  elif [[ "${OPTION}" == "s" ]]; then
    USE_SP='true'
  else
    echo 'Invalid Option'
    exit 1
  fi
done



# Remove the options while leaving the remaining arguments.
shift "$(( OPTION - 1 ))"

if [[ "${#}" -gt 0 ]]
then
  usage
fi

log 'Generating a password.'

PASSWORD=$(date +%s%N${RANDOM}${RANDOM} | sha256sum | head -c${LENGTH})

# Append a special character if requested to do so.
if [[ "${USE_SP}" = 'true' ]]
then
  log 'Selecting a random special character.'
  SPECIAL_CHARACTER=$(echo '!@#$%^&*()_-+=' | fold -w1 | shuf | head -c1)
  PASSWORD="${PASSWORD}${SPECIAL_CHARACTER}"
fi

log 'Done.'
log 'Here is the password:'

# Display the password.
echo "${PASSWORD}"

exit 0

