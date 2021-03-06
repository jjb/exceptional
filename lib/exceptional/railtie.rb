require 'exceptional'
require 'rails'

module Exceptional
  class Railtie < Rails::Railtie

    initializer "exceptional.middleware" do |app|

      config_file = File.join(Rails.root, "/config/exceptional.yml")
      Exceptional::Config.load config_file if File.exist?(config_file)
      # On Heroku config is loaded via the ENV so no need to load it from the file

      if Exceptional::Config.should_send_to_api?
        Exceptional.logger.info("Loading Exceptional #{Exceptional::VERSION} for #{Rails::VERSION::STRING}")
        if defined?(ActionDispatch::ShowExceptions)
          ActionDispatch::ShowExceptions.send(:include,Exceptional::ShowExceptions)
        else
          app.config.middleware.use "Rack::RailsExceptional"
        end
      end
    end
  end
end
