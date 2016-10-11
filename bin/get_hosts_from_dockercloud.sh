parseContainers () {
  while read container_uri
  do
#    echo "container uri: $container_uri"
    details=$(curl -s -H "Authorization: $DOCKERCLOUD_AUTH" -H "Accept: application/json" ${DOCKERCLOUD_REST_HOST}${container_uri})
    hostname=$(echo $details | jq -r '.hostname')
    domainname=$(echo $details | jq -r '.domainname')
    private_ip=$(echo $details | jq -r '.private_ip')
    name=$(echo $details | jq -r '.name')
    line="$private_ip $hostname"
#    if [ -n $domainname && $domainname -nq "null"]
#    then
      line="$line.$domainname $hostname"
#    fi
#    echo "line: $line"
    echo $line >> /tmp/hosts
#    curl -s -H "Authorization: $DOCKERCLOUD_AUTH" -H "Accept: application/json" ${DOCKERCLOUD_REST_HOST}${container_uri} | jq -r '@sh "\(.private_ip) \(.hostname) \(.hostname).\(.domainname) \(.name)" ' >> /tmp/hosts
  done
}

parseServices () {
  while read service_uri
  do
#    echo "service uri: $service_uri"
    curl -s -H "Authorization: $DOCKERCLOUD_AUTH" -H "Accept: application/json" ${DOCKERCLOUD_REST_HOST}${service_uri} | jq -r '.containers[]' | tr -d '",' > /tmp/containers
#    echo "containers: $(cat /tmp/containers)"
    cat /tmp/containers | parseContainers
  done
}

# get my stack's URI
stack_uri=$(curl -s -H "Authorization: $DOCKERCLOUD_AUTH" -H "Accept: application/json" ${DOCKERCLOUD_REST_HOST}${DOCKERCLOUD_SERVICE_API_URI} | jq -r '.stack')

# empty previous /tmp/hosts
echo > /tmp/hosts

# get my stack's details, and parse my brother services
curl -s -H "Authorization: $DOCKERCLOUD_AUTH" -H "Accept: application/json" ${DOCKERCLOUD_REST_HOST}${stack_uri} | jq '.services[]' | tr -d '",' > /tmp/services

#echo "services: $(cat /tmp/services)"

cat /tmp/services | parseServices

