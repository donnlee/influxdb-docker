# Includes docker-compose.yml (config) for running official grafana container. See 'grafana' subdir.

# Example environment variables for setup and run of influxdb container

'docker run' or Rancher service environment vars:

ADMIN_USER = root

COLLECTD_BINDING = :25826

COLLECTD_DB = my_db

INFLUXDB_INIT_PWD = myPassw0rd

PRE_CREATE_DB = my_db

# Expose ports

  - 25826:25826/udp
  - 8083:8083/tcp
  - 8086:8086/tcp

# Persistence

Storage volume should be mounted at /data
