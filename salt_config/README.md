### An repository for Salt-Stack formulas and configurations intended to leverage an OpenStack certified public cloud.

It is currently able to fully support the follow operational cases:

+ ![Progress](http://progressed.io/bar/100)   [OpenStack as a Cloud Provider](/salt_config/etc_salt/cloud.providers.d) - A sample Cloud Provider configuration using INAP's Agile as an example



Incuded is a skeleton config for congirufing Saltstack to work with [Agile](http://www.internap.com/cloud/public-cloud/) as Salt Cloud Provider.

### About
Agile is built using an OpenStack implementation that adheres very closely to the intended specifications and hence will likely be able to support any OpenStack feature functionality provided by [Apache Libcloud](https://libcloud.apache.org/), which is part of the [SaltStack Libcloud](https://docs.saltstack.com/en/latest/topics/cloud/install/index.html) project.

When in doubt please see SaltStack's documentation for [OpenStack and Salt](https://github.com/openstack/openstack-salt)


Follows configuration syntax for Salt `2016.3.1` 

[Sample Formulas](https://github.com/salt-formulas/openstack-salt/tree/master/formulas)
