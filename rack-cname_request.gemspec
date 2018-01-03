lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rack/cname_request/version'

Gem::Specification.new do |spec|
  spec.name          = 'rack-cname_request'
  spec.version       = Rack::CnameRequest::VERSION
  spec.authors       = ['FENG Zhichao']
  spec.email         = ['flankerfc@gmail.com']

  spec.summary       = %q{rack middleware to handle request from cname proxy}
  spec.description   = %q{rack middleware to handle request from cname proxy}
  spec.homepage      = 'https://github.com/flanker/rack-cname_request'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.15'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
