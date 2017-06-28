### An repository for Salt-Stack formulas and configurations intended to leverage an OpenStack certified public cloud.

It is currently able to fully support the follow operational cases:

+ ![Progress](http://progressed.io/bar/100)   [OpenStack as a Cloud Provider](/salt_config/etc_salt/cloud.providers.d) - A sample Cloud Provider configuration using INAP Agile as an example
+ ![Progress](http://progressed.io/bar/100)   [Cloud Instance Profile](/salt_config/etc_salt/cloud.profiles.d) - A sample Instance Profile configuration using INAP Agile as an example
+ ![Progress](http://progressed.io/bar/100)   [Mapfile using Cloud Instance Profile](/salt_config/etc_salt/cloud.mapfile) - A sample cloud mapfile
+ ![Progress](http://progressed.io/bar/80)  [dnsmasq with automagic PTR](/salt_config/srv_salt/dnsmasq) - A sample dnsmasq formula that provides for automagic resolution of PTR based on the IP address queried.

### What does it do?

The supplied configs leverage Salt-Stacks implementation of [Apache Libcloud](https://libcloud.apache.org/) to provision and manage resources ontop of a OpenStack certified public cloud.
- Manage cloud resources in a composeable fashion
- Follow Salt-Stack best practices and guidelines
- Build Salt formulas to automate operational and application delivery tasks

## How to use
> **Note:** These are currently configured to be used with an Internap Agile Cloud account.

1. Install Salt-Stack according to [best practices](https://docs.saltstack.com/en/latest/topics/installation/)

2. Clone this repo:
  ```bash
   git clone https://github.com/dlotterman/inap_demo_platform/
  ```
3. Copy the directories in the repo to the `etc` and `src` files configured (by default `/etc/salt/` and `/srv/salt`).
  * `rsync -a salt_config/etc_salt/ /etc/salt/`
  * `rsync -a salt_config/srv_salt/ /srv/salt/`
4. Update `*.cfg` files according to documentation provided in the config READMEs. 
  * `/etc/salt/cloud.providers.d/agile.conf`
  * `/etc/salt/cloud.profiles.d/*.conf`
  * `/etc/salt/cloud.mapfile`
5. You can now launch instances according to the mapfile:
```sudo salt-cloud -m /etc/salt/cloud.mapfile```
6. You can now interact with instances according to Salt-Stack best practices:
``` sudo salt '*' test.ping```

### What is INAP Agile
A [OpenStack Certified Public Cloud](https://www.openstack.org/marketplace/public-clouds/) that implements best of breed networking and builds on core OpenStack functionality such as [Ironic](https://wiki.openstack.org/wiki/Ironic) to provision and manage [Bare Metal Chassis](http://www.internap.com/cloud/) as cloud resources.


### Documentation
When in doubt please see SaltStack's documentation for [OpenStack and Salt](https://github.com/openstack/openstack-salt)

Follows configuration syntax for Salt `2016.3.1` 

[Sample Formulas](https://github.com/salt-formulas/openstack-salt/tree/master/formulas)
