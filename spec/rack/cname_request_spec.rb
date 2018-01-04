require 'spec_helper'

RSpec.describe Rack::CnameRequest do

  include Rack::Test::Methods

  def load_app(name)
    Rack::Builder.new do
      use Rack::CnameRequest, cname_header_key: 'CNAME_FROM', only: 'cname.server.com'
      map('/ok') do
        run proc { |env|
          [200, {'Content-Type' => 'text/html'}, ['some text']]
        }
      end
      map('/redirect_with_path_only') do
        run proc { |env|
          [301, {'Content-Type' => 'text/html', 'Location' => '/path'}, ['redirecting']]
        }
      end
      map('/redirect_with_path_and_different_host') do
        run proc { |env|
          [301, {'Content-Type' => 'text/html', 'Location' => 'http://a.new.host.com/path'}, ['redirecting']]
        }
      end
      map('/redirect_with_path_and_original_host') do
        run proc { |env|
          [301, {'Content-Type' => 'text/html', 'Location' => 'http://cname.server.com/path'}, ['redirecting']]
        }
      end
    end
  end

  let(:app) { load_app('test') }

  it 'does not apply if response is not a redirection' do
    get '/ok'
    expect(last_response.headers['Location']).to be_nil
  end

  it 'does not modify redirection location if request not sent from cname proxy' do
    get '/redirect_with_path_and_original_host'
    expect(last_response.headers['Location']).to eq('http://cname.server.com/path')
  end

  it 'does not modify redirection location if location is not in the white list' do
    header 'CNAME_FROM', 'xyz.custom.com'
    get '/redirect_with_path_and_different_host'
    expect(last_response.headers['Location']).to eq('http://a.new.host.com/path')
  end

  it 'modifies redirection location if request sent from cname proxy and matches white list' do
    header 'CNAME_FROM', 'xyz.custom.com'
    get '/redirect_with_path_and_original_host'
    expect(last_response.headers['Location']).to eq('http://xyz.custom.com/path')
  end

end
