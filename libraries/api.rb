#
# Cookbook Name:: serverdensity
# Library:: api

# require_relative was introduced in 1.9.2. This makes it
# available to younger rubies.  It trys hard to not re-require
# files.

unless Kernel.respond_to?(:require_relative)
  module Kernel
    def require_relative(path)
      desired_path = File.expand_path('../' + path.to_str, caller[0])
      shortest = desired_path
      $:.each do |path|
        path += '/'
        if desired_path.index(path) == 0
          candidate = desired_path.sub(path, '')
          shortest = candidate if candidate.size < shortest.size
        end
      end
      require shortest
    end
  end
end

module ServerDensity
  module API

    class << self
      def configure(version, *args)
        if configured?
          Chef::Log.warn('Server Density API has already been configured')
          false
        else
          case version.to_i
            when 1 then class << self; include V1; end
            when 2 then class << self; include V2; end
            else raise 'Invalid Server Density API version'
          end
          @version = version
          initialize(*args)
          true
        end
      end

      def configured?
        not @version.nil?
      end
    end

  end
end
