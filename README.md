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

## How it works

check_graphite, asks for a small window of metrics, and computes an average over the last valid
points collected, it then checks the value against supplied thresholds.

NaN values are not taken into account in the average
