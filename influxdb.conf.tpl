### Welcome to the InfluxDB configuration file.

# Once every 24 hours InfluxDB will report anonymous data to m.influxdb.com
# The data includes raft id (random 8 bytes), os, arch, version, and metadata.
# We don't track ip addresses of servers reporting. This is only used
# to track the number of instances running and the versions, which
# is very helpful for us.
# Change this option to true to disable reporting.
reporting-disabled = true

# we'll try to get the hostname automatically, but if it the os returns something
# that isn't resolvable by other servers in the cluster, use this option to
# manually set the hostname
# hostname = "localhost"

###
### [meta]
###
### Controls the parameters for the Raft consensus group that stores metadata
### about the InfluxDB cluster.
###

[meta]
  # Where the metadata/raft database is stored
  dir = "/data/meta"

  retention-autocreate = true

  # If log messages are printed for the meta service
  logging-enabled = true
  pprof-enabled = false

  # The default duration for leases.
  lease-duration = "1m0s"

###
### [data]
###
### Controls where the actual shard data for InfluxDB lives and how it is
### flushed from the WAL. "dir" may need to be changed to a suitable place
### for your system, but the WAL settings are an advanced configuration. The
### defaults should work for most systems.
###

[data]
  # Controls if this node holds time series data shards in the cluster
  enabled = true

  dir = "/data/data"

  # These are the WAL settings for the storage engine >= 0.9.3
  wal-dir = "/data/wal"
  wal-logging-enabled = true
  data-logging-enabled = true

  # Whether queries should be logged before execution. Very useful for troubleshooting, but will
  # log any sensitive data contained within a query.
  # query-log-enabled = true

  # Settings for the TSM engine

  # CacheMaxMemorySize is the maximum size a shard's cache can
  # reach before it starts rejecting writes.
  # cache-max-memory-size = 524288000

  # CacheSnapshotMemorySize is the size at which the engine will
  # snapshot the cache and write it to a TSM file, freeing up memory
  # cache-snapshot-memory-size = 26214400

  # CacheSnapshotWriteColdDuration is the length of time at
  # which the engine will snapshot the cache and write it to
  # a new TSM file if the shard hasn't received writes or deletes
  # cache-snapshot-write-cold-duration = "1h"

  # MinCompactionFileCount is the minimum number of TSM files
  # that need to exist before a compaction cycle will run
  # compact-min-file-count = 3

  # CompactFullWriteColdDuration is the duration at which the engine
  # will compact all TSM files in a shard if it hasn't received a
  # write or delete
  # compact-full-write-cold-duration = "24h"

  # MaxPointsPerBlock is the maximum number of points in an encoded
  # block in a TSM file. Larger numbers may yield better compression
  # but could incur a performance peanalty when querying
  # max-points-per-block = 1000

###
### [cluster]
###
### Controls non-Raft cluster behavior, which generally includes how data is
### shared across shards.
###

[cluster]
  shard-writer-timeout = "5s" # The time within which a remote shard must respond to a write request.
  write-timeout = "10s" # The time within which a write request must complete on the cluster.
  max-concurrent-queries = 0 # The maximum number of concurrent queries that can run. 0 to disable.
  query-timeout = "0s" # The time within a query must complete before being killed automatically. 0s to disable.
  max-select-point = 0 # The maximum number of points to scan in a query. 0 to disable.
  max-select-series = 0 # The maximum number of series to select in a query. 0 to disable.
  max-select-buckets = 0 # The maximum number of buckets to select in an aggregate query. 0 to disable.

###
### [retention]
###
### Controls the enforcement of retention policies for evicting old data.
###

[retention]
  enabled = true
  check-interval = "30m"

###
### [shard-precreation]
###
### Controls the precreation of shards, so they are available before data arrives.
### Only shards that, after creation, will have both a start- and end-time in the
### future, will ever be created. Shards are never precreated that would be wholly
### or partially in the past.

[shard-precreation]
  enabled = true
  check-interval = "10m"
  advance-period = "30m"

###
### Controls the system self-monitoring, statistics and diagnostics.
###
### The internal database for monitoring data is created automatically if
### if it does not already exist. The target retention within this database
### is called 'monitor' and is also created with a retention period of 7 days
### and a replication factor of 1, if it does not exist. In all cases the
### this retention policy is configured as the default for the database.

[monitor]
  store-enabled = true # Whether to record statistics internally.
  store-database = "_internal" # The destination database for recorded statistics
  store-interval = "10s" # The interval at which to record statistics

###
### [admin]
###
### Controls the availability of the built-in, web-based admin interface. If HTTPS is
### enabled for the admin interface, HTTPS must also be enabled on the [http] service.
###

[admin]
  enabled = true
  bind-address = ":8083"
  https-enabled = false
  https-certificate = "/etc/ssl/influxdb.pem"

###
### [http]
###
### Controls how the HTTP endpoints are configured. These are the primary
### mechanism for getting data into and out of InfluxDB.
###

[http]
  enabled = true
  bind-address = ":8086"
  auth-enabled = false
  log-enabled = true
  write-tracing = false
  pprof-enabled = false
  https-enabled = false
  https-certificate = "/etc/ssl/influxdb.pem"
  max-row-limit = 10000

###
### [[graphite]]
###
### Controls one or many listeners for Graphite data.
###

[[graphite]]
  enabled = false
  # database = "graphite"
  # bind-address = ":2003"
  # protocol = "tcp"
  # consistency-level = "one"

  # These next lines control how batching works. You should have this enabled
  # otherwise you could get dropped metrics or poor performance. Batching
  # will buffer points in memory if you have many coming in.

  # batch-size = 5000 # will flush if this many points get buffered
  # batch-pending = 10 # number of batches that may be pending in memory
  # batch-timeout = "1s" # will flush at least this often even if we haven't hit buffer limit
  # udp-read-buffer = 0 # UDP Read buffer size, 0 means OS default. UDP listener will fail if set above OS max.

  ### This string joins multiple matching 'measurement' values providing more control over the final measurement name.
  # separator = "."

  ### Default tags that will be added to all metrics.  These can be overridden at the template level
  ### or by tags extracted from metric
  # tags = ["region=us-east", "zone=1c"]

  ### Each template line requires a template pattern.  It can have an optional
  ### filter before the template and separated by spaces.  It can also have optional extra
  ### tags following the template.  Multiple tags should be separated by commas and no spaces
  ### similar to the line protocol format.  There can be only one default template.
  # templates = [
  #   "*.app env.service.resource.measurement",
  #   # Default template
  #   "server.*",
  # ]

###
### [collectd]
###
### Controls the listener for collectd data.
###

[collectd]
  enabled = {{ COLLECTD_ENABLED }}
  # Example value for COLLECTD_BINDING is :25826 (Note ":" colon!)
  bind-address = "{{ COLLECTD_BINDING }}"
  database = "{{ COLLECTD_DB }}"
  typesdb = "/usr/share/collectd/types.db"

  # These next lines control how batching works. You should have this enabled
  # otherwise you could get dropped metrics or poor performance. Batching
  # will buffer points in memory if you have many coming in.

  # batch-size = 1000 # will flush if this many points get buffered
  # batch-pending = 5 # number of batches that may be pending in memory
  # batch-timeout = "1s" # will flush at least this often even if we haven't hit buffer limit
  # read-buffer = 0 # UDP Read buffer size, 0 means OS default. UDP listener will fail if set above OS max.

###
### [opentsdb]
###
### Controls the listener for OpenTSDB data.
###

[opentsdb]
  enabled = false
  # bind-address = ":4242"
  # database = "opentsdb"
  # retention-policy = ""
  # consistency-level = "one"
  # tls-enabled = false
  # certificate= ""
  # log-point-errors = true # Log an error for every malformed point.

  # These next lines control how batching works. You should have this enabled
  # otherwise you could get dropped metrics or poor performance. Only points
  # metrics received over the telnet protocol undergo batching.

  # batch-size = 1000 # will flush if this many points get buffered
  # batch-pending = 5 # number of batches that may be pending in memory
  # batch-timeout = "1s" # will flush at least this often even if we haven't hit buffer limit

###
### [[udp]]
###
### Controls the listeners for InfluxDB line protocol data via UDP.
###

[[udp]]
  enabled = false
  # bind-address = ""
  # database = "udp"
  # retention-policy = ""

  # These next lines control how batching works. You should have this enabled
  # otherwise you could get dropped metrics or poor performance. Batching
  # will buffer points in memory if you have many coming in.

  # batch-size = 1000 # will flush if this many points get buffered
  # batch-pending = 5 # number of batches that may be pending in memory
  # batch-timeout = "1s" # will flush at least this often even if we haven't hit buffer limit
  # read-buffer = 0 # UDP Read buffer size, 0 means OS default. UDP listener will fail if set above OS max.

  # set the expected UDP payload size; lower values tend to yield better performance, default is max UDP size 65536
  # udp-payload-size = 65536

###
### [continuous_queries]
###
### Controls how continuous queries are run within InfluxDB.
###

[continuous_queries]
  log-enabled = true
  enabled = true
  # run-interval = "1s" # interval for how often continuous queries will be checked if they need to run
