require 'rack/cname_request'

app = Rack::Builder.app do
  use Rack::CnameRequest, cname_header_key: 'CNAME_FROM'

  run lambda { |env| [301, {'Location' => '/login', 'Content-Type' => 'text/html'}, ['redirecting to /login']] }
end

run app
