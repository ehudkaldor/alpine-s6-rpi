parseServiceLinks() {
  while read service_uri
  do
    CONTAINERS=$(curl -s -H "Authorization: $DOCKERCLOUD_AUTH" -H "Accept: application/json" ${DOCKERCLOUD_REST_HOST}${service_uri} | jq -r ".containers[]")
    echo "container URIs: $CONTAINERS"
    for CONT_URI in $CONTAINERS
    do
      ANS=$(curl -s -H "Authorization: $DOCKERCLOUD_AUTH" -H "Accept: application/json" ${DOCKERCLOUD_REST_HOST}${CONT_URI})
      export LINE
      if [[ -n $(echo $ANS | jq -r '.domainname') && $(echo $ANS | jq -r '.domainname') != 'null' ]]
      then 
        LINE=$(echo $ANS | jq -r '. | "\(.private_ip) \(.hostname) \(.hostname).\(.domainname)"')
      else
        LINE=$(echo $ANS | jq -r '. | "\(.private_ip) \(.hostname)"') 
      fi
      if [[ $(echo $ANS | jq -r '.hostname') != $(echo $ANS | jq -r '.name') ]]
      then
        LINE="$LINE $(echo $ANS | jq -r '.name')"
      fi
      echo $LINE >> /tmp/hosts
    done
  done
}

if [ -n "${DOCKERCLOUD_AUTH}" ] 
then
  STACKS=$(curl -s -H "Authorization: $DOCKERCLOUD_AUTH" -H "Accept: application/json" ${DOCKERCLOUD_REST_HOST}/api/app/v1/stack/ | jq -r '.objects[]')
  export FOUND=false
  for STACK in "${STACKS[@]}"
  do
    STACK_URI=$(echo $STACK | jq -r '.resource_uri')
    if [ -n $(echo $STACK | jq -r '.services[] | select(. | contains ("${DOCKERCLOUD_SERVICE_API_URI}"))') ]
    then
      FOUND=true
      echo $STACK | jq -r '.services[]' | parseServiceLinks
    fi
  done
  if [ ! FOUND ]
  then
    echo "My service uri not found in any stack"
  fi



#  SERVICES=$(curl -s -H "Authorization: $DOCKERCLOUD_AUTH" -H "Accept: application/json" ${DOCKERCLOUD_REST_HOST}/api/app/v1/stack/ | jq -r ".objects[0] | .services[]")
#  echo "services URIs: $SERVICES"
#  for SRV_URI in $SERVICES
#  do
#    CONTAINERS=$(curl -s -H "Authorization: $DOCKERCLOUD_AUTH" -H "Accept: application/json" ${DOCKERCLOUD_REST_HOST}${SRV_URI} | jq -r ".containers[]")
#    echo "container URIs: $CONTAINERS"
#    for CONT_URI in $CONTAINERS
#    do
#      CONT_DETAILS=$(curl -s -H "Authorization: $DOCKERCLOUD_AUTH" -H "Accept: application/json" ${DOCKERCLOUD_REST_HOST}${CONT_URI} | jq -r ".hostname, .domainname, .private_ip, .name")
#      echo "details: $CONT_DETAILS"
#    done
#  done
fi
