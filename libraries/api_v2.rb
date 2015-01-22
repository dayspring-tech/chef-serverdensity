#
# Cookbook Name:: serverdensity
# Library:: api-v2

require_relative 'api_v2_alerts'
require_relative 'api_v2_devices'

module ServerDensity
  module API
    
    module V2
      include Base
      include Alerts
      include Devices

      protected

      def base_url
        'https://api.serverdensity.io'
      end

      def error(err, message)
        puts err.inspect
        Chef::Log.warn(message)
        nil
      end

      def find_resource(type, meta)
        get('/inventory/resources', :params => {
          :filter => Chef::JSONCompat.to_json(validate(meta)),
          :type => type
        }).body.first
      rescue => err
        error(err, "Unable to retrieve #{type} from Serverdensity")
      end

      private

      def initialize(token)
        params :token => token
      end
    end

  end
end
