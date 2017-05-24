### An repository for Salt-Stack formulas and configurations intended to leverage an OpenStack certified public cloud.

It is currently able to fully support the follow operational cases:

+ ![Progress](http://progressed.io/bar/100)   [OpenStack as a Cloud Provider](/salt_config/etc_salt/cloud.providers.d) - A sample Cloud Provider configuration using INAP's Agile as an example
+ ![Progress](http://progressed.io/bar/100)   [OpenStack as a Cloud Instance Profile](/salt_config/etc_salt/cloud.profiles.d) - A sample Instance Profile configuration using INAP's Agile as an example
+ ![Progress](http://progressed.io/bar/80)  [dnsmasq with auto PRT](/salt_config/srv_salt/dnsmasq) - A sample dnsmasq formula that provides for automagic resolution of reverse DNS to a domain record based on PTR.

### What does it do?

The supplied configs leverage Salt-Stacks implementation of [Apache Libcloud](https://libcloud.apache.org/) to provision and manage resources ontop of a OpenStack certified public cloud.
- Manage cloud resources in a composeable fashion
- Follow Salt-Stack best practices and guidelines
- Build Salt formulas to automate operational and application delivery tasks


### What is INAP Agile
A [OpenStack Certified Public Cloud](https://www.openstack.org/marketplace/public-clouds/) that implements best of breed networking and builds on core OpenStack functionality such as [Ironic](https://wiki.openstack.org/wiki/Ironic) to provision and manage [Bare Metal Chassis](http://www.internap.com/cloud/) as cloud resources.


### Documentation
When in doubt please see SaltStack's documentation for [OpenStack and Salt](https://github.com/openstack/openstack-salt)

Follows configuration syntax for Salt `2016.3.1` 

[Sample Formulas](https://github.com/salt-formulas/openstack-salt/tree/master/formulas)
