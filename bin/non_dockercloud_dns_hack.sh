echo "running $0"
env_vars=$(env | grep ".*_PORT_.*_TCP_ADDR=" | cut -d= -f1 | tr '\n' ' ' )
echo "env_vars: $env_vars"
echo "#Auto Generated - DO NOT CHANGE" >> /tmp/hosts
echo "running loop on env_vars"
for env_var in $env_vars
do
    echo "env_var: $env_var"
    host=$(echo $env_var | awk -F"_PORT_" '{print $1;}' | tr '_' '-' | tr '[:upper:]' '[:lower:]' )
    echo "host: $host"
    ip=$(eval "echo \$$env_var")
    echo "ip: $ip"
    echo "${ip} ${host}" >> /tmp/hosts
    while ! ping -c 1 -q ${ip} &> /dev/null
    do
        echo "Waiting for linked IP address ${ip} to be reachable"
        sleep 1
    done
done
