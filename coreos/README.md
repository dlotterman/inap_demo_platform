## CoreOS on INAP BMC

This section will have supporting documentation added shortly.

This `openstack` command will provisiong a BMC Virtual Instance with the needed `bmc_ignition.json` file in the userdata field in order to properly boot a CoreOS instance on INAP BMC.

```
openstack server create \
--flavor "$FLAVOR_NAME" \
--image $COREOS_GLANCE_IMAGE \
--security-group $SG3_id  \
--security-group $SG2_ID \
--key-name $COREOS_SSHKEY \
--network $PUBLIC_NETWORK_ID \
--network $PRIVATE_NETWORK_ID\
--user-data ignition/json/bmc_ignition.json \
"$COREOS_INSTANCE_NAME"
```
