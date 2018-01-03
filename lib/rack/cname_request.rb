require 'rack/cname_request/version'

module Rack
  class CnameRequest

    attr_reader :http_cname_header_key

    def initialize(app, cname_header_key: nil)
      @app = app
      @http_cname_header_key = "HTTP_#{cname_header_key}"
    end

    def call(env)
      status, headers, body = @app.call env

      if headers['Location'] && env[http_cname_header_key]
        uri = URI(headers['Location'])
        uri.host = env[http_cname_header_key]
        headers['Location'] = uri.to_s
      end

      [status, headers, body]
    end

    private

  end
end
