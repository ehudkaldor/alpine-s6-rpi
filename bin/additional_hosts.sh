echo "running bin/additional_hosts.sh"
if [ -n "$BA_ADDITIONAL_HOSTS" ] && [ -n "$DOCKERCLOUD_SERVICE_FQDN" ]
then
    nameserver=$(cat /etc/resolv.conf | grep nameserver | head -1 | cut -d' ' -f2)
    search=$(cat /etc/resolv.conf | grep search | head -1 | cut -d' ' -f2)
    service1=$(echo $DOCKERCLOUD_SERVICE_FQDN | cut -d'.' -f2-)
    service2=$(echo $DOCKERCLOUD_SERVICE_FQDN | cut -d'.' -f3-)
    cont1=$(echo $DOCKERCLOUD_CONTAINER_FQDN | cut -d'.' -f2-)
    cont2=$(echo $DOCKERCLOUD_CONTAINER_FQDN | cut -d'.' -f3-)

#    echo "nameserver: $nameserver"
#    echo "search: $search"
#    echo "service1: $service1"
#    echo "service2: $service2"
#    echo "cont1: $cont1"
#    echo "cont2: $cont2"

    echo "running loop on BA_ADDITIONAL_HOSTS ($BA_ADDITIONAL_HOSTS)"
    for host in $BA_ADDITIONAL_HOSTS
    do
        echo "host: $host"
        for suffix in $search $service1 $service2 $cont1 $cont2
        do
            if ping -t 1 -c 1 ${host}.${suffix} &> /dev/null
            then
                ip=$( nslookup ${host}.${suffix} | grep Address | tail -1 | cut -d: -f2  | cut -d' ' -f2 2>/dev/null)
                echo "${ip} ${host}" >> /tmp/hosts
                echo "Added additional host ${host}.${suffix}=${ip}"
                break
              fi
          done
    done
fi


