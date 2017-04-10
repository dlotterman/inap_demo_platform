# Apache MapReduce with Agile Swift 

The `swift_core_site.xml` file contains an example configuration for a hadoop environment to view a Agile Swift container as a HDFS data source, allowing both `hdfs  dfs` file operations as well as `mapred job` functions.

## Agile specific configuration paramters

### Default FS
> ```
  <property>
    <name>fs.defaultFS</name>
    <value>swift://hadoopcontainer.agile/</value>
  </property>
```
> Configures the default HDFS namespace to be the configured Swift Container, allows for default `hdfs dfs -ls /` type behavior

### Auth URL
> ```
     <property>
      <name>fs.swift.service.agile.auth.url</name>
      <value>https://identity.api.cloud.iweb.com/v2.0/tokens</value>
      <description>Agile NYJ</description>
    </property>
```
> Configures the OpenStack authentication endpoint. Currently requires the V2 endpoint.

### Agile Tenant
> ```
    <property>
      <name>fs.swift.service.agile.tenant</name>
      <value>inap-$PROJECT_STRING</value>
    </property>
```
> Confures the Openstack Tenant parameter, should be the `Name` string visible in the [Agile Horizon Projects Page] (https://horizon.internap.com/identity/)
