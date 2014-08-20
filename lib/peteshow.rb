require 'peteshow/helpers'
require 'peteshow/engine' if defined? Rails
require 'peteshow/railtie' if defined? ::Rails::Railtie

module Peteshow
  autoload :Config, 'peteshow/config'

  def self.config
    @config ||= Config.new
  end

  def self.configure
    yield self.config
  end
end

