
### Scripts for creating Tableau Bridge on Linux Docker Container, and for running/stopping bridge containers.

write a bash script for creating bridge on linux docker container. here is the documentation: https://help.tableau.com/current/online/en-us/to_bridge_linux_install.htm

use chrome v2 extension to generate yaml file:

tokens:
  - name: bridgectl-1
    secret: X3HAaU...
  - name: bridgectl-2
    secret: OvtC...
bridge:
  agent_prefix: bridgectl
  replica_count: 1
  pool_name: testdevdays
  pool_id: e0739483-689f-400c-9925-e8a0f11424b3
  user_email: jfluckiger@tableau.com
  pod_url: prod-useast-a.online.tableau.com
  site_name: fluke23
  db_drivers:
    - amazon_athena
    - amazon_emr_hadoop_hive
    - amazon_redshift
    - cloudera_hive



### Additional requirements tasks:
Write bash script to create Dockerfile with base_image of UBI8 (or redhat9)

Take the list of drivers from the yaml file, write it to the variables.sh file

download and include container_image_builder

run container_image_builder to install drivers

initialize bridge with settings from yaml. we can use the yq utility to parse the yaml.

