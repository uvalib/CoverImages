# This file is used by Rack-based servers to start the application.

require_relative 'config/environment'

require 'rack'
require 'prometheus/middleware/collector'
require 'prometheus/middleware/exporter'

use Rack::Deflater, if: ->(_, _, _, body) { body.respond_to?( :map ) && body.map(&:bytesize).reduce(0, :+) > 512 }
use Prometheus::Middleware::Exporter
use Prometheus::Middleware::Collector,

# we customize these because we dont want to keep distinct metrics for every get
counter_label_builder: ->(env, code) {
  # normalize path, replace IDs to keep cardinality low.
  normalized_path = env['PATH_INFO'].to_s.
      gsub(/\/cover_images\/.*$/, '/cover_images/:id').
      gsub(/\/system\/cover_images\/.*$/, '/system/cover_images/:id')
  {
      code:         code,
      method:       env['REQUEST_METHOD'].downcase,
      path:         normalized_path
  }
},
    duration_label_builder: -> ( env, code ) {
  # normalize path, replace IDs to keep cardinality low.
  normalized_path = env['PATH_INFO'].to_s.
      gsub(/\/cover_images\/.*$/, '/cover_images/:id').
      gsub(/\/system\/cover_images\/.*$/, '/system/cover_images/:id')
  {
      method:       env['REQUEST_METHOD'].downcase,
      path:         normalized_path
  }
}

run Rails.application
