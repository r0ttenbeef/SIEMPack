#!/bin/bash

# Compitable with ubuntu server only

install_dependencies() {
    packages=( "docker" "docker.io" "docker-compose" "git" "wget" )
    echo "[*] Updating apt repositories"
    apt-get update -qqq >/dev/null
    for package in ${packages[@]};do
        echo "[+] Installing $package"
        apt-get install -y -qqq $package >/dev/null
    done

    if [ ! -f "wazuh_plugin.zip" ];then
        echo "[*] Downloading Wazuh plugin"
        wget -nv -q --show-progress https://github.com/wazuh/wazuh-kibana-app/releases/download/v4.2.5-7.12.1/wazuh_kibana-4.2.5_7.12.1-1.zip -O wazuh_plugin.zip
    fi

    if [ ! -f "wazuh-filebeat.tar.gz" ];then
        echo "[*] Downloading Wazuh filebeat module"
        wget -nv -q --show-progress https://packages.wazuh.com/4.x/filebeat/wazuh-filebeat-0.1.tar.gz -O wazuh-filebeat.tar.gz
    fi
}

container_mem_tweak() {
    echo "[*] Increasing max_map_count on the host"
    if [[ ! $(cat /etc/sysctl.conf | grep 'vm.max_map_count') ]];then
        echo "vm.max_map_count=262144" >> /etc/sysctl.conf
        sysctl -w vm.max_map_count=262144
    fi
}

start_deployment() {
    if [ ! -d elasticsearch ];then mkdir elasticsearch;fi
    chmod 777 elasticsearch thehive
    chmod 750 ./misp-files/wait-for-it.sh
    if [ -f docker-compose.yml ];then
        echo "[+] Starting deployment"
        docker-compose down;docker-compose up -d --build
    else
        echo "[x] docker-compose.yml file doesn't exist!"
        exit 3
    fi
}

if [[ $(lsb_release -d | awk '{print $2}') -ne "Ubuntu" ]];then
    echo "[x] The deployment should be executed on ubuntu server."
    exit 1
elif [ $EUID -ne 0 ];then
    echo "[x] The deployment script should be run as root."
    exit 2
fi

install_dependencies
container_mem_tweak
start_deployment
