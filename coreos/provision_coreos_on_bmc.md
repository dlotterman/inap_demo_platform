## Provisioning CoreOS on INAP BMC Guide

**Last Updated November 2019**

Consult the [CoreOS OpenStack documentation](https://coreos.com/os/docs/latest/booting-on-openstack.html) for the most recent CoreOS image build for the relevant channel. 
Note that this is only for identifying the correct image to download. 
As of 11/2019, the documentation on that page was out of date with CoreOS's current state of `Ignition` vs `cloud-init` adoption.

#### Download the most current "stable" image:
```
$ wget https://stable.release.core-os.net/amd64-usr/current/coreos_production_openstack_image.img.bz2
$ bunzip2 coreos_production_openstack_image.img.bz2
```

#### Upload the bunzip'ed image to Glance (BMC's Image Management API)

Before we can proceed, we need to validate that the following OpenStack tools have been installed and configured, which falls outside of the scope of this guide. Please see this repositories README.md regarding initial / boilerplate documentation for [BMC OpenStack](../README.md).

```
$ glance image-create --name Container-Linux \
  --container-format bare \
  --disk-format qcow2 \
  --file coreos_production_openstack_image.img
```

Please note, BMC Glance does **not** support labelling uploaded images as public. They must be uploaded and referenced on a per account basis.

#### Getting required provisioning configuration from BMC

In order to launch an instance using the CoreOS image, we need to identify a couple of required configuration details first.

Please Note that identifying information such as
 UUID's for OpenStack objects or string names will have been scrubbed or replace
d with generated content for this documentation.

**Networks**

The CoreOS instance will need to be launched with the appropriate networks attached. To get the network ID's to assign as provisioning, we can get the list of networks in our BMC account.

```
$ openstack network list
+--------------------------------------+--------------------+--------------------------------------+
| ID                                   | Name               | Subnets                              |
+--------------------------------------+--------------------+--------------------------------------+
| 97607f2f-d1f8-464a-b9e6-65b1b0364284 | inap-18454-WAN5555 | 020989ba-57f9-4gb9-a91f-4f90376dc18b |
| 79d1daaf-b623-4d39-b61d-4d4c6c3c6ce7 | inap-18454-LAN5555 | gb5ee178-557a-47db-8bb4-5a10e01db99 |
+--------------------------------------+--------------------+--------------------------------------+
```

So our two referenceable network ID's are:
```
97607f2f-d1f8-464a-b9e6-65b1b0364284
79d1daaf-b623-4d39-b61d-4d4c6c3c6ce7
```
For our public / private networks respectively.

We must also get the ID's of any Security Groups that we want to apply to the CoreOS instance at provision time:

```
$ openstack security group list
+--------------------------------------+-------------------+------------------------+----------------------------------+------+
| ID                                   | Name              | Description            | Project                          | Tags |
+--------------------------------------+-------------------+------------------------+----------------------------------+------+
| d95ce9ae-7171-4efc-ad89-fa73789294a1 | webserver_allowed |                        | 58f9s3s7fhcf4555b67667300f2f8cad | []   |
| dff2f6bc-f677-4d73-9ad5-ceb989ba610b | default           | Default security group | 58f9s3s7fhcf4555b67667300f2f8cad | []   |
| 8e6dd669-6e7f-425f-b402-9f82374796f0 | rdp_allowed       |                        | 58f9s3s7fhcf4555b67667300f2f8cad | []   |
| aad13cf3-d557-41ca-8976-29a20f4ae669 | global_egress     |                        | 58f9s3s7fhcf4555b67667300f2f8cad | []   |
| 70523bb3-7045-4808-ac80-f7d52a6789ce | home              |                        | 58f9s3s7fhcf4555b67667300f2f8cad | []   |
+--------------------------------------+-------------------+------------------------+----------------------------------+------+
```

We will also need the public SSH key that will be assigned to the user `core` after succesful launch of the instance:

```
$ openstack keypair list
+-------------------------+-------------------------------------------------+
| Name                    | Fingerprint                                     |
+-------------------------+-------------------------------------------------+
| veryfakekey_orchestr    | bb:93:g3:ec:9e:e1:4c:aa:37:d1:9f:34:14:f6:fc:e2 |
+-------------------------+-------------------------------------------------+
```

We also need the ID for our CoreOS Glance image in case we did not record it while initially uploading it to glance:

```
$ openstack image list | grep Container| fda929b9-4fb8-4141-b58f-0655cb7bf8ee | Container-Linux                    | active |
| b5b6d5df-0e08-4c0f-9bd5-1322ea153cf0 | Container-Linux                    | active |
```

Finally we need our available flavors:

```
$ openstack flavor list
+----------------------------------------+----------------------------------------+-------+------+-----------+-------+-----------+
| ID                                     | Name                                   |   RAM | Disk | Ephemeral | VCPUs | Is Public |
+----------------------------------------+----------------------------------------+-------+------+-----------+-------+-----------+
| A1.1                                   | A1.1                                   |  1024 |   20 |         0 |     1 | True      |
| A1.16                                  | A1.16                                  | 16384 |  320 |         0 |    16 | True      |
| A1.2                                   | A1.2                                   |  2048 |   40 |         0 |     2 | True      |
| A1.4                                   | A1.4                                   |  4096 |   80 |         0 |     4 | True      |
| A1.8                                   | A1.8                                   |  8192 |  160 |         0 |     8 | True      |
| AS2.1xE3-1230v2.8GB.1x1TB.HDD.1GbE     | AS2.1xE3-1230v2.8GB.1x1TB.HDD.1GbE     |  8192 | 1000 |         0 |     8 | True      |
| AS2.1xE3-1270v2.32GB.1x1TB.HDD.1GbE    | AS2.1xE3-1270v2.32GB.1x1TB.HDD.1GbE    | 32768 | 1000 |         0 |     8 | True      |
| AS2.1xE5-1620v3.32GB.1x2TB.HDD.1GbE    | AS2.1xE5-1620v3.32GB.1x2TB.HDD.1GbE    | 32768 | 2000 |         0 |     8 | True      |
| AS2.1xE5-1650v3.64GB.1x2TB.HDD.1GbE    | AS2.1xE5-1650v3.64GB.1x2TB.HDD.1GbE    | 65536 | 2000 |         0 |    12 | True      |
| AS2.2xE5-2620v1.32GB.1x1TB.HDD.1GbE    | AS2.2xE5-2620v1.32GB.1x1TB.HDD.1GbE    | 32768 | 1000 |         0 |    24 | True      |
| AS2.2xE5-2630v3.64GB.1x2TB.HDD.10GbE   | AS2.2xE5-2630v3.64GB.1x2TB.HDD.10GbE   | 65536 | 2000 |         0 |    32 | True      |
| AS2.2xE5-2630v3.64GB.1x480GB.SSD.10GbE | AS2.2xE5-2630v3.64GB.1x480GB.SSD.10GbE | 65536 |  480 |         0 |    32 | True      |
| B1.1                                   | B1.1                                   |  4096 |   20 |         0 |     1 | True      |
| B1.16                                  | B1.16                                  | 61440 |  320 |         0 |    16 | True      |
| B1.2                                   | B1.2                                   |  8192 |   40 |         0 |     2 | True      |
| B1.4                                   | B1.4                                   | 15360 |   80 |         0 |     4 | True      |
| B1.8                                   | B1.8                                   | 30720 |  160 |         0 |     8 | True      |
+----------------------------------------+----------------------------------------+-------+------+-----------+-------+-----------+
```

*Please note:* at this time, this documentation and tooling should work for both Virtual and Bare Metal flavors.


#### Bootstrapping 

BMC bootstraps newly provisioned instances through a pairing of OpenStack's "ConfigDrive" and [cloud-init](https://cloudinit.readthedocs.io/en/latest/). BMC **explicitly** does not support the OpenStack HTTP meta-data endpoint for security and operational reasons.

Ignition, CoreOS's new provisioning engine, does not currently support gathering all of it's needed information from "cloud-init" or "ConfigDrive". It has a preference for gathering its needed configuration from the HTTP meta-data endpoint, which BMC does not expose.

Ignition is however able to detect the presence of the "ConfigDrive" when it begins its provisioning engine, just not to completion of configuring the instance. This step leverages Ignitions Configuration Template and JSON configuration mechanisms to sideload the required information into the instance through ConfigDrive "UserData" in order for it to complete its provisioning tasks and deliver a functioning CoreOS instance.

More documentation on Ignition can be found [here](https://coreos.com/ignition/docs/latest/). 

Please not that as of 11/2019, the documentation between Ignition, CoreOS and some of the ancillary tooling appears to be out of sync or entirely out of date, and some creative interpretation of guidance from that documentation may be required. Some useful links:

* [Ignition Configuration Transpiler](https://coreos.com/os/docs/latest/overview-of-ct.html)
* [Ignition Configuration Validator](https://coreos.com/validate/)

The [json](ignition/json/) files included this repo contain all the information required to sideload the needed configuration into the CoreOS instance at provision time. The key stanza is the (absurd looking to humans) [storage](https://github.com/dlotterman/inap_demo_platform/blob/16a664aa27a57af684adc9177bfee66d561fe39c/coreos/ignition/json/bmc_ignition.json#L23P) stanza which writes a [simple](scripts/) bash script to `/var/lib/bmc/` which is then constructed into a `bmc_metadata` service to be managed by `systemd` in order to populate the isntance with the needed data from the "ConfigDrive". Examples of how to construct that script into the json file can be found in the Ignition configuration [examples](ignition/ct/) included in the repo.

At this time due to limitations in the Ignition transpiler and YAML tooling, it is strongly recommend to provide the JSON file as the userdata file rather than a Ignition `ct` YAML file, despite that generally not being best practice with other `tool` -> `json` workflows.

The [json](ignition/json/bmc_ignition.json) file only needs to be on disk where ever the instance is being launched from. 

The [json](ignition/json/bmc_ignition.json) file will be loaded into the instance via the "ConfigDrive", where it will then be picked up by Ignition, which will then write out the needed `systemd` and other data to complete the configuration.

If leveraging tools such as Chef, Puppet, Ansible or Salt, just include the [json](ignition/json/bmc_ignition.json) file as part of the "UserData" flag for launching an instance.

The only edit that needs to be made to the json file is to change any attributes of the `etcd-member` service to match your specific needs, such as the [discovery-token](https://github.com/dlotterman/inap_demo_platform/blob/16a664aa27a57af684adc9177bfee66d561fe39c/coreos/ignition/json/bmc_ignition.json#L32).

```
openstack server create \
--flavor "$FLAVOR_NAME" \
--image $COREOS_GLANCE_IMAGE \
--security-group $SG3_ID  \
--security-group $SG2_ID \
--key-name $COREOS_SSHKEY \
--network $PUBLIC_NETWORK_ID \
--network $PRIVATE_NETWORK_ID\
--user-data ignition/json/bmc_ignition.json \
"$COREOS_INSTANCE_NAME"
```

After the instance is launched, you should be able to `ssh` to the instance using the standard `core` user.
