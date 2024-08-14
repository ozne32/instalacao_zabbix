#!/bin/bash
echo 'coloque o ip do servidor'
read ipServidor
echo 'coloque o hostname'
read hostname
comeco_instalacao(){
    apt update 
    apt upgrade -y
}
 
#essa parte é a parte da documentação --> aqui está instalando para debian
debian(){
    wget https://repo.zabbix.com/zabbix/7.0/debian/pool/main/z/zabbix-release/zabbix-release_7.0-2+debian12_all.deb  
    dpkg -i zabbix-release_7.0-2+debian12_all.deb 
}
ubuntu(){ #versão 24.04
    wget https://repo.zabbix.com/zabbix/7.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_7.0-2+ubuntu24.04_all.deb
    dpkg -i zabbix-release_7.0-2+ubuntu24.04_all.deb
}
#vai até aqui
final_instalacao(){
    apt update
    apt install zabbix-agent2 zabbix-agent2-plugin-* -y
    #mudando o /etc/zabbix/zabbix_agent2.conf
    sed -i "s/^Server=127.0.0.1/Server=$ipServidor/" /etc/zabbix/zabbix_agent2.conf 
    sed -i "s/^ServerActive=127.0.0.1/ServerActive=$ipServidor/" /etc/zabbix/zabbix_agent2.conf 
    sed -i "s/Hostname=Zabbix server/Hostname=$hostname/" /etc/zabbix/zabbix_agent2.conf
    #fim do /etc/zabbix/zabbix_agent2.conf
    #restartando os serviços
    systemctl restart zabbix-agent2  
    systemctl enable zabbix-agent2
}
case $1 in 
    -D | debian) comeco_instalacao
                    debian
                    final_instalacao;;
    -U | ubuntu) comeco_instalacao
                    ubuntu
                    final_instalacao;;
esac

