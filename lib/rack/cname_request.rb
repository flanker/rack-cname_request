require 'rack/cname_request/version'

module Rack
  class CnameRequest

    attr_reader :http_cname_header_key, :host_whitelist

    def initialize(app, cname_header_key: nil, only: [])
      @app = app
      @http_cname_header_key = "HTTP_#{cname_header_key}"
      @host_whitelist = only || []
    end

    def call(env)
      status, headers, body = @app.call env
      original_location = headers['Location']
      if original_location
        modifier = LocationModifier.new(original_location, env[http_cname_header_key], host_whitelist: host_whitelist)
        headers['Location'] = modifier.modified_location if modifier.should_modify?
      end

      [status, headers, body]
    end

  end

  class LocationModifier

    attr_reader :location_uri, :cname_header_value, :host_whitelist

    def initialize(location, cname_header_value, host_whitelist: [])
      @location_uri = URI(URI.escape(location)) if location
      @cname_header_value = cname_header_value
      @host_whitelist = host_whitelist || []
    end

    def should_modify?
       comes_from_cname_proxy? && location_host_in_white_list?
    end

    def modified_location
      location_uri.host = cname_header_value
      location_uri.to_s
    end

    private

    def comes_from_cname_proxy?
      cname_header_value
    end

    def location_host_in_white_list?
      host_whitelist.include?(location_uri.host)
    end

  end
end
