**Get quota limits on OpenStack CLI for BMC**
`openstack quota show --default`

**Upload VMDK to glance with VMware adapter for LSI**
`time glance image-create --name "vmdk_test3" --disk-format vmdk --container-format bare --property vmware_adaptertype="lsiLogic" --property vmware_disktype="preallocated" --property vmware_ostype="debian7" <  /export/vmdk_test/vmdk_test-flat.vmdk`

