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

