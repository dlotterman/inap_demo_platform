### Salt Doc Guide:
https://docs.saltstack.com/en/latest/topics/cloud/openstack.html

* Master IP should be the private IP address of the salt master instace
..* For best practices, this should be mapped to an IP address reserved by
neutron for the purposes of salt master with A and PTR DNS records correctly
configured for "salt" in the default search domain

* User should be the api-$USER_NUM_STRING credential pair generated in the
INAP Agile portal and used to authenticate with Horizon

* compute_region is the region as visible in the region dropdown list:
https://horizon.internap.com/project/
E.G `nyj01`

* tenant is the Agile project name visible here:
https://horizon.internap.com/identity/

* networks are the UUID-like formed strings visible with the network pages:
https://horizon.internap.com/project/networks/
