echo "running /bin/dns_hack.sh"
env_vars=$(env | grep ".*_NAME=" | cut -d= -f1 | tr '\n' ' ' )
echo "env_vars: $env_vars"
echo "#Auto Generated - DO NOT CHANGE" > /tmp/hosts
nameserver=$(cat /etc/resolv.conf | grep nameserver | head -1 | cut -d' ' -f2)
echo "nameserver: $nameserver"
echo "runnning loop on env_vars"
for env_var in $env_vars
do
  echo "env_var: $env_var"
  link=$(echo ${env_var%_NAME}  | tr '_' '-' | tr '[:upper:]' '[:lower:]')
  echo "link: $link"
  domain=$(cat /etc/resolv.conf | grep search | cut -d' ' -f2)
  echo "domain: $domain"
  if ping -c 1 "${link}.${domain}" &> /dev/null
  then
      echo "pinging ${link}.${domain} succeeded"
      ip=$(ping -c 1 "${link}.${domain}"| head -1 | cut -d'(' -f2 |  cut -d')' -f1)
  elif nslookup "${link}.${domain}" ${nameserver}  &> /dev/null
  then
      echo "pinging ${link}.${domain} failed"
      ip=$( nslookup "${link}.${domain}" ${nameserver}  | grep Address | tail -1 | cut -d: -f2  | cut -d' ' -f2 2>/dev/null)
      echo "ip: $ip"
  else
      ip=
  fi
  if [ -n "$ip" ]
  then
    echo adding ${ip} ${link} to /tmp/hosts"
    echo "${ip} ${link}" >> /tmp/hosts
  else
    echo "ip ${link}.${domain} skipped, it didn't resolve."
    echo "ip ${link}.${domain} skipped, it didn't resolve." 1>&2
  fi

done

