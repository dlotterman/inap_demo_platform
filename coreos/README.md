## CoreOS on INAP BMC

This section will have supporting documentation added shortly.

[Provisioning a CoreOS instance on BMC](provision_coreos_on_bmc.md)

This `openstack` command will provisiong a BMC Virtual Instance with the needed `bmc_ignition.json` file in the userdata field in order to properly boot a CoreOS instance on INAP BMC.

Note that the JSON file needs to be updated with the `etcd-member` systemd unit file template to reflect the correct `etcd` service configuration, namely like the etcd discovery token.

