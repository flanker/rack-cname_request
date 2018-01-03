require 'spec_helper'

RSpec.describe Rack::CnameRequest do

  include Rack::Test::Methods

  def load_app(name)
    Rack::Builder.new do
      use Rack::CnameRequest, cname_header_key: 'CNAME_FROM'
      map('/ok') do
        run proc { |env|
          [200, {'Content-Type' => 'text/html'}, ['some text']]
        }
      end
      map('/home') do
        run proc { |env|
          [301, {'Content-Type' => 'text/html', 'Location' => 'http://my.test.com/login'}, ['redirecting']]
        }
      end
    end
  end

  let(:app) { load_app('test') }

  it 'does not apply if response is not a redirection' do
    get '/ok'
    expect(last_response.headers['Location']).to be_nil
  end

  it 'does not modify redirection locaiton if request not sent from cname proxy' do
    get '/home'
    expect(last_response.headers['Location']).to eq('http://my.test.com/login')
  end

  it 'modifies redirection location if request sent from cname proxy' do
    header 'CNAME_FROM', 'xyz.custom.com'
    get '/home'
    expect(last_response.headers['Location']).to eq('http://xyz.custom.com/login')
  end

end
