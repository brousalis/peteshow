require 'json'

package = open('package.json').read
json = JSON.parse(package)

Gem::Specification.new do |s|
  s.name        = json['name']
  s.version     = json['version']
  s.author      = json['author']['name']
  s.email       = json['author']['email']
  s.summary     = 'Javascript plugin for filling out forms with fake data'
  s.description = 'Javascript plugin for filling out forms with fake data for testing purposes'
  s.homepage    = json['homepage']

  s.files           = `git ls-files`.split($\)
  s.require_paths   = ['lib']
end
