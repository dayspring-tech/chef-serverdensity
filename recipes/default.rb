#
# Cookbook Name:: serverdensity
# Recipe:: default

return unless node.serverdensity.enabled

chef_gem 'rest_client'
require 'rest_client'

case node[:platform]

  when 'debian', 'ubuntu'
    include_recipe 'apt'

    apt_repository 'serverdensity' do
      key 'https://www.serverdensity.com/downloads/boxedice-public.key'
      uri 'https://www.serverdensity.com/downloads/linux/deb'
      distribution 'all'
      components ['main']
      action :add
    end

    dpkg_autostart 'sd-agent' do
      allow false
    end

    package 'python-dev'
    package 'python-mysqldb'

  when 'redhat', 'centos', 'fedora', 'scientific', 'amazon'

    yum_key "boxedice-public" do
      url "https://www.serverdensity.com/downloads/boxedice-public.key"
      action :add
    end

    yum_repository 'serverdensity' do
      description 'Server Density sd-agent'
      url 'https://www.serverdensity.com/downloads/linux/redhat/'
      key 'boxedice-public'
    end

    package 'python-devel'
    package 'MySQL-python'

end

package 'sd-agent'

file '/etc/sd-agent/config.cfg' do
  action :delete
  not_if { ::File.symlink?(path) }
end

service 'sd-agent' do
  supports [:start, :stop, :restart]
  action :nothing
end

directory '/etc/sd-agent/conf.d'
directory node.serverdensity.plugin_dir do
  recursive true
end
