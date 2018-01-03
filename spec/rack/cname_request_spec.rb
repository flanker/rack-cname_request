require 'spec_helper'

RSpec.describe Rack::CnameRequest do
  it 'has a version number' do
    expect(Rack::CnameRequest::VERSION).not_to be nil
  end

  it 'does something useful' do
    expect(true).to eq(true)
  end
end
