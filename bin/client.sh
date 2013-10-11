#!/bin/bash
source /opt/bin/util.sh
OPTS="hc:v"
clientName=

function help() {
cat << EOF
client.sh
    -h help
    -c client name
    -v version
EOF
}
function get_opts() {
    while getopts ${OPTS} OPTION
    do
        case ${OPTION} in
            h) 
                help;
                exit 0;
                ;;
            c)
                i "aaaa"
                clientName=${OPTARG}
                i ${OPTARG}
                ;;
            ?)
                #unknow option, just omit them
                e "Unknow option ${OPTION} : ${OPTARG}"
                ;;
        esac
    done
}
function check_p4_client_exist() {
    [ -z $clientName ] && e "Missing client name" && help && exit -1
    (p4 clients -u jacky_liu| grep "\W${clientName}\W" >> /dev/zero)
    [ "$?" -ne "0" ] && e "Client(${clientName}) doesn't exist." && exit -1
}
function clean_p4_client() {
    #p4 -c ${clientName} client -o
    rootline=$(p4 -c ${clientName} client -o| grep "^Root:")
    rootline=${rootline/:/ }
    i $rootline;
    read -a values <<< $rootline
    i ${values[1]}
    root=${values[1]}
    clientline=$(p4 -c ${clientName} client -o| grep "^Client:")
    clientline=${clientline/:/ }
    i $clientline;
    read -a values <<< $clientline
    i ${values[1]}
    ok "Will remove client($clientName)..."
    ok "Client($clientName} get removed..."
    ok "Will remove local files..."
    ok "Local files get removed..."
    e "failed to clean"
    #p4 -u jakcy_liu client -d $
}
get_opts $@;
check_p4_client_exist;
clean_p4_client;
