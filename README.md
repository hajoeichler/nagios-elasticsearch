check_elasticsearch is a nagios module to query ElasticSearch

[![Build Status](https://secure.travis-ci.org/jbraeuer/check-elasticsearch.png)](http://travis-ci.org/jbraeuer/check-elasticsearch)

## Example

check_graphite accepts the following options:

* `-H` or `--host`: the ES to connect to
* `-P` or `--port`: the port to connect on
* `-A` or `--action`: the item to check
  * cluster_health
  * cluster_data_nodes
  * cluster_unassigned_shards
* `-w`: warning threshold for the metric
* `-c`: critical threshold for the metric
* `-t`: timeout after which the metric should be considered unknown

