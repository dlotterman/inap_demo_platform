# Apache MapReduce with Agile Swift 

The `swift_core_site.xml` file contains an example configuration for a hadoop environment to view a Agile Swift container as a HDFS data source, allowing both `hdfs  dfs` file operations as well as `mapred job` functions.

### Requirements

* Apache Hadoop 2.X
* Mapreduce V1 (see caveats below for MRv2 / Yarn)
* The [Hadoop Openstack JAR](https://mvnrepository.com/artifact/org.apache.hadoop/hadoop-openstack) must be loaded or placed the Hadoop environment paths

## Agile specific configuration paramters

### Default FS
```
<property>
    <name>fs.defaultFS</name>
    <value>swift://hadoopcontainer.agile/</value>
</property>
```
> Configures the default HDFS namespace to be the configured Swift Container, allows for default `hdfs dfs -ls /` type behavior

### Auth URL
```
<property>
      <name>fs.swift.service.agile.auth.url</name>
      <value>https://identity.api.cloud.iweb.com/v2.0/tokens</value>
      <description>Agile NYJ</description>
</property>
```
> Configures the OpenStack authentication endpoint. Currently requires the V2 endpoint.

### Agile Tenant
```
<property>
      <name>fs.swift.service.agile.tenant</name>
      <value>inap-$PROJECT_STRING</value>
</property>
```
> Configures the Openstack Tenant parameter, should be the `Name` string visible in the [Agile Horizon Projects Page](https://horizon.internap.com/identity/)


### Agile Username
```
<property>
      <name>fs.swift.service.agile.username</name>
      <value>api-$API_NUM_STRING</value>
</property>
```
> Configures the Opestack username paramter, should be the `api-` username string used to authenticate with the Horizon portal as well as visible in the [Top Right](https://horizon.internap.com/project/) corner of the Horizon portal once authenticated.

### Agile Region
```
<property>
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
> Configures the password parameter. For Agile, use this is the password associated with the `agile.username` user used while authenticating through the horizon portal. Not to be confused with other documentation that states "API token", this must be the user password for the account. Should there be restrictions on plaintext passwords in on disk files, this can be set by environment variable or by `hdfs dfs` or `mapred job` configuration flags. Please see the Hadoop Openstack documentation below.

### Documentation
* [Hadoop Openstack](https://hadoop.apache.org/docs/stable2/hadoop-openstack/index.html) integration documentation page
* 


### Caveats

* MRv2 / YARN is unable to address swift:// namespaces for submitted distributed jobs. This is because the `hadoop-openstack` swift implementation does not return valid user / group strings to directory / file listings (it returns empty strings). When submitting a job to YARN, it performs a safety check on permissions which does not currently support empty user / group strings. `s3n` solves for this by a configuration available to return a default user / name.
