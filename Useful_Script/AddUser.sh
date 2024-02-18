#! /bin/bash

if [[ ${UID} -eq 0 ]]
then
    echo "Your are Root User"
else
    echo "Please login with root Access"
    exit 1
fi

if [[ ${#} -lt 1 ]]
then 
    echo "Please supply the username"
    exit 1
fi

  USERNAME=${1}
  PASSWORD=$( date +%s+%N | sha256sum | head -c48 )
  echo -n "${USERNAME}: ${PASSWORD}"

n=${#}
echo
echo -n  "Name - "
for(( i=2; i<=n; i++ ));
do
  COMMENT2=${!i}
  echo -n "${COMMENT2} "
done
useradd -c "${COMMENT2}" -m ${USERNAME}
echo ${PASSWORD} | passwd --stdin ${USERNAME}
if [[ ${?} -eq 1 ]]
then
    echo "Password has not been assigned to username"
else
    echo "Password created and assigned to username"
fi
echo
echo  "HostName is ${HOSTNAME}"
echo
