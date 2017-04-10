## OpenStack HEAT with Agile Swift

Leveraging Agile Swift for data persistance, a MapReduce platform can be built that can scale on demand to meet capacity and performance requirements, while minimizing the operational overhead of having to support and maintain a highly available and performant HDFS cluster.

This platform would be operationally stateless while being able to meet the elastic computational requirements of ETL workloads such as operational intelligence (web server log analysis) or business intelligence.


### Example environment

* Data Persistence - Agile Swift
* MapReduce (MRv1) Task Tracker - Agile Instance
    * A dedicated instance running the MRv1 Task Tracker
    * Leverages snapshots for RTO / RPO of the 
    * Dedicated IP address [reserved through Neutron](http://kb.internap.com/bare-metal/adding-additional-ips-to-a-vm/)
* MapReduce (MRv1) worker instances
    * Provisioned and managed by Openstack HEAT
    * Launched from an image built with the required configurations to communicated with the Task Tracker master of the cluster
    * Scales according to HEAT template using HDFS as their persistant store.
