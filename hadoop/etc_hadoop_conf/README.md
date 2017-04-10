# Apache MapReduce with Agile Swift 

The `swift_core_site.xml` file contains an example configuration for a hadoop environment to view a Agile Swift container as a HDFS data source, allowing both `hdfs  dfs` file operations as well as `mapred job` functions.

## Agile specific configuration paramters

### Default FS
```<property>
    <name>fs.defaultFS</name>
    <value>swift://hadoopcontainer.agile/</value>
  </property>
```
> Configures the default HDFS namespace to be the configured Swift Container, allows for default `hdfs dfs -ls /` type behavior

### Auth URL
``` <property>
      <name>fs.swift.service.agile.auth.url</name>
      <value>https://identity.api.cloud.iweb.com/v2.0/tokens</value>
      <description>Agile NYJ</description>
    </property>
```
> Configures the OpenStack authentication endpoint. Currently requires the V2 endpoint.

### Agile Tenant
``` <property>
      <name>fs.swift.service.agile.tenant</name>
      <value>inap-$PROJECT_STRING</value>
    </property>
```
> Configures the Openstack Tenant parameter, should be the `Name` string visible in the [Agile Horizon Projects Page](https://horizon.internap.com/identity/)


### Agile Username
```<property>
      <name>fs.swift.service.agile.username</name>
      <value>api-$API_NUM_STRING</value>
    </property>
```
> Configures the Opestack username paramter, should be the `api-` username string used to authenticate with the Horizon portal as well as visible in the [Top Right](https://horizon.internap.com/project/) corner of the Horizon portal once authenticated.

### Agile Region
```    <property>
      <name>fs.swift.service.agile.region</name>
      <value>nyj01</value>
    </property>
```
> Configures the Agile region for Swift and other resources

### Agile Password
```    <property>
      <name>fs.swift.service.agile.password</name>
      <value>$AGILE_API_PASS_STRING</value>
    </property>
```
> Configures the password parameter. For Agile, use this is the password associated with the `agile.username` user used while authenticating through the horizon portal. Not to be confused with other documentation that states "API token", this must be the user password for the account.
