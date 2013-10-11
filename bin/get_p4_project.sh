#!/bin/bash
source /opt/bin/util.sh

p4path=
p4user=
p4path=
p4clientname=
p4branch=
localpath=
ws=

OPTIONS="vc:h"
function get_client_spec()
{
    curPath=`pwd`;
    echo "hello";
    echo ${curPath}
}

function usage() {
cat<<EOF
    Usage:
        -h  show help information
        -c  client spec path
        -v  verbose information
EOF
}


function test_params() {
    printf "${URed}hello, test_params"
    printf $*
    printf $@
}
function verbose() {
cat << EOF
    version 1.0.0
EOF
}
function parse_paramters() {
    while getopts ${OPTIONS} OPTION
    do
        case ${OPTION} in
            h)
                usage;
                exit 0;
                ;;
            c)
                p4path=$OPTARG
                ;;
            v)
                verbose;
                exit 0
                ;;
            ?)
                echo "Unknonw option(${OPTION})"
                exit 0
                ;;
        esac
    done
}
function make_sure_p4_login() {
    p4user=${P4USER}
    i ${p4user}
    [ -z "$p4user" ] && read -e -p "input your p4user name:" p4user
    [ -z $p4user ] && e "Can't find p4 user" && exit -1
    i "Use p4 user(${p4user})"
    (p4 -u ${p4user} clients -u ${p4user} > /dev/zero)
    if [ ! "$?" == "0" ]; then
        (p4 -u ${p4user} login)
    fi
    [ ! "$?" == "0" ] && e "user failes to login!" && exit -1
    ok "login user ${p4user} sucessfully."
}
function replace_client_spec() {
    f=$ws/clientspec.txt
    l=$(cat $f | grep ^Client:)
    read -a arr <<< ${l/:/ }

    path=$(pwd)/$ws;
    path=${path//\//\\\/}
    ok $ws
    ok $path
    ok "${arr[1]}/${ws}"
    cat $f | sed 's/^Root:.*/'"Root:$path"'/g' | sed 's/'"${arr[1]}"'/'"${ws}"'/g' > $ws/c.txt
    cat $ws/c.txt | p4 client  -i
    p4 -c $ws sync 
}

function prepare_client_spec() {
    hostname=$(hostname)
    echo $hostname;
    $(p4 print $p4path > /dev/null)
    [ "$?" -ne "0" ] && e "Invalide p4 path($p4path)." && exit -1
    v="${p4path//\// }"
    read -a arr <<<$v

    [ ${#arr[@]} -lt 5 ] && e "Invalid p4 path($p4path)." && exit -1;
    p4branch=${arr[${#arr[@]} - 3]}
    platform=${arr[${#arr[@]} - 5]}
    #ok $p4branch
    #ok "default client name: ${hostname}-${platform}-${p4branch}"
    ws="${hostname}-${platform}-${p4branch}"
    read -e -p "Input your workspace name(${ws}):" ws0
    ws=${ws0:-${ws}}

    ok "${ws}"

    [ -e ${ws} -a -f ${ws} ] && e "Already existed as file." && exit -1
    mkdir -p ${ws}
    #i "p4 -u ${p4user} print ${p4path}"
    (p4 print -q ${p4path} > ${ws}/clientspec.txt)
    replace_client_spec;
}
parse_paramters $@;
make_sure_p4_login;
prepare_client_spec;

#replace_client_spec;
