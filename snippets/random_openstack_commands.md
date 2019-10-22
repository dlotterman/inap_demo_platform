Below are scratch snippets for the [OpenStack CLI](https://docs.openstack.org/mitaka/user-guide/) specific to INAP's Bare Metal Cloud (BMC)

### Get quota limits on OpenStack CLI for BMC

```
openstack quota show --default
```

### Upload VMDK to glance with VMware adapter for LSI

```
time glance image-create --name "vmdk_test3" \
--disk-format vmdk --container-format bare --property vmware_adaptertype="lsiLogic" \
--property vmware_disktype="preallocated" \
--property vmware_ostype="debian7" <  /export/vmdk_test/vmdk_test-flat.vmdk
```

### Getting a Network ID

```
openstack network list
```

or

```
openstack network show -c id inap-SCRUB-WANSCRUB
```

### Launch instance with specific networks

```
openstack server create \
--flavor "A1.2" \
--image IMAGE_UUID \
--security-group SG_UUID  \
--security-group SG_UUID  \
--key-name KEY_NAME \
--network NETWORK_UUID \
--network NETWORK_UUID \
"HOSTNAME"
```


