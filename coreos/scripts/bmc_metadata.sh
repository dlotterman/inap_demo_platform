#!/usr/bin/bash

CONFIG_DRIVE="/media/configdrive/openstack/latest"

NETWORKD_UNIT_DIR=/etc/systemd/network

mask2cdr ()

{
local x=${1##*255.}
set -- 0^^^128^192^224^240^248^252^254^ $(( (${#1} - ${#x})*2 )) ${x%%.*}
x=${1%%$3*}
echo "/$(( $2 + (${#x}/4) ))"
}

mkdir -p /run/metadata/
rm /run/metadata/bmc > /dev/null 2>&1

for NETWORK in $(jq .networks[].id $CONFIG_DRIVE/network_data.json)
do
CLEAN_NETWORK=$(echo $NETWORK | sed s/\"//g)
UNIT_FILE=$(echo /etc/systemd/network/"$CLEAN_NETWORK"_unit.network)
LINK=$(jq -r '.networks[] | select(.id == '$NETWORK') | .link' < $CONFIG_DRIVE/network_data.json)
IP=$(jq -r '.networks[] | select(.id == '$NETWORK') | .ip_address' < $CONFIG_DRIVE/network_data.json)
NETMASK=$(jq -r '.networks[] | select(.id == '$NETWORK') | .netmask' < $CONFIG_DRIVE/network_data.json)
CIDR=$(mask2cdr $NETMASK)
GATEWAY=$(jq -r '.networks[] | select(.id == '$NETWORK') | .routes[].gateway' < $CONFIG_DRIVE/network_data.json)
DNS0=$(jq -r '.services[0] | select(.type == "dns") | .address' < $CONFIG_DRIVE/network_data.json)
DNS1=$(jq -r '.services[1] | select(.type == "dns") | .address' < $CONFIG_DRIVE/network_data.json)

echo "[Match]" > $UNIT_FILE
echo "Name=$LINK" >> $UNIT_FILE
echo "[Network]" >> $UNIT_FILE
echo "Address=$IP$CIDR" >> $UNIT_FILE

if [ ! -z "$GATEWAY" ]; then
    echo "Gateway=$GATEWAY" >> $UNIT_FILE
    echo "DNS=$DNS0" >> $UNIT_FILE
    echo "DNS=$DNS1" >> $UNIT_FILE
fi
echo "BMC_"$CLEAN_NETWORK"_IP="$IP"" >> /run/metadata/bmc
done

BMC_INSTANCE_HOSTNAME=$(jq -r .name $CONFIG_DRIVE/meta_data.json)

BMC_CORE_PASSWD=$(jq -r .admin_pass < $CONFIG_DRIVE/meta_data.json)

hostnamectl set-hostname $BMC_INSTANCE_HOSTNAME

echo -e "$BMC_CORE_PASSWD\n$BMC_CORE_PASSWD" | passwd core > /dev/null 2>&1

jq -r .public_keys[] < $CONFIG_DRIVE/meta_data.json > /home/core/.ssh/authorized_keys

chown core:core /home/core/.ssh/authorized_keys
chmod 0644 /home/core/.ssh/authorized_keys

systemctl disable coreos-metadata.service
systemctl restart systemd-networkd

