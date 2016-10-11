echo "running /bin/get_hosts_from_dockercloud.sh"
parseServiceLinks() {
    while read ip service_link host
    do
#        curl -s -H "Authorization: $DOCKERCLOUD_AUTH" -H "Accept: application/json" ${DOCKERCLOUD_SERVICE_API_URL}${service_link} > /tmp/cur_service
#        echo "curl -s -H "Authorization: $DOCKERCLOUD_AUTH" -H "Accept: application/json" ${DOCKERCLOUD_SERVICE_API_URL}${service_link} yielded " `cat /tmp/cur_service`
        curl -s -H "Authorization: $DOCKERCLOUD_AUTH" -H "Accept: application/json" ${DOCKERCLOUD_SERVICE_API_URL} > /tmp/cur_service
        echo "curl -s -H "Authorization: $DOCKERCLOUD_AUTH" -H "Accept: application/json" ${DOCKERCLOUD_SERVICE_API_URL} yielded " `cat /tmp/cur_service`
        fqdn=$(cat /tmp/cur_service | jq -r '.public_dns')
        echo "fqdn: $fqdn"
        host=$(cat /tmp/cur_service  | jq -r '.name')
        echo "host: $host"
        echo "${ip} ${host} ${fqdn}" >> /tmp/hosts
    done
    echo "content of /tmp/hosts: " `cat /tmp/hosts`
}


#if [ -n "${DOCKERCLOUD_AUTH}" ] && [ -n "${TUTUM_API_CALLS_FOR_DNS}" ]
if [ -n "${DOCKERCLOUD_AUTH}" ] 
then
    curl -s -H "Authorization: $DOCKERCLOUD_AUTH" -H "Accept: application/json" ${DOCKERCLOUD_REST_HOST}/api/app/v1/container/ > /tmp/containers.raw
    echo "curl -s -H "Authorization: $DOCKERCLOUD_AUTH" -H "Accept: application/json" ${DOCKERCLOUD_REST_HOST}/api/app/v1/container/ yielded " `cat /tmp/containers.raw`
    cat /tmp/containers.raw | jq -r '.objects  | map ( "\(.private_ip) \(.name) \(.public_dns)" ) | .[]' | tr -d '"' >> /tmp/hosts
    echo "content of /tmp/hosts: " `cat /tmp/hosts`
    cat /tmp/containers.raw | jq -r '.objects  | map ( "\(.private_ip) \(.service) \(.name)" ) | .[]' | tr -d '"' | parseServiceLinks
fi
