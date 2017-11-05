# require 'datadog/statsd'
#
# env = ENV['RACK_ENV']
# DATADOG_HOST = ENV.fetch('DATADOG_HOST')
# DATADOG_PORT = ENV.fetch('DATADOG_PORT')
# DATADOG_ENV = "env-#{env}"
#
# statsd_adapter = Datadog::Statsd.new(DATADOG_HOST, DATADOG_PORT, tags: [DATADOG_ENV], namespace: 'labstats')
#
# # Measurements::StatsdService.adapter = adapter
