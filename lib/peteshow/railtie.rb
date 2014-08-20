require 'peteshow'
require 'rails'

class Peteshow::Railtie < Rails::Railtie
  config.peteshow = ActiveSupport::OrderedOptions.new

  initializer "peteshow.configure" do |app|
    Peteshow.configure do |config|
      config.enabled = app.config.peteshow[:enabled]
    end
  end

  initializer 'peteshow.action_controller' do
    ActiveSupport.on_load :action_controller do
      helper Peteshow::Helpers
    end
  end
end
