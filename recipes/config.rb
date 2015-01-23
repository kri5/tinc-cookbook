#
# Cookbook Name:: tinc-cookbook
# Recipe:: config
#
# Copyright (C) 2015 Christophe Courtaut
#
# All rights reserved - Do Not Redistribute
#

file '/etc/tinc/nets.boot' do
  owner 'root'
  group 'root'
  mode '0400'
  content "#{node['tinc']['network_name']}"
end

network_config_dir_path = "/etc/tinc/#{node['tinc']['network_name']}"

directory network_config_dir_path do
  owner 'root'
  group 'root'
  mode '0755'
end

public_key_path = "#{network_config_dir_path}/rsa_key.pub"
private_key_path = "#{network_config_dir_path}/rsa_key.priv"

execute "Keys generation for tinc" do
  command "tincd --config #{network_config_dir_path} --generate-keys"
  not_if { ::File.exists?(private_key_path) && ::File.exists?(public_key_path) }
end

directory "#{network_config_dir_path}/hosts" do
  owner 'root'
  group 'root'
  mode '0755'
end

file public_key_path do
  owner 'root'
  group 'root'
  mode '0444'
end

file private_key_path do
  owner 'root'
  group 'root'
  mode '0400'
end

hostname = node['fqdn'].gsub(/[.\-_]+/, '')
hostfile_path = "#{network_config_dir_path}/hosts/#{hostname}"

template hostfile_path do
  source 'host.config.erb'
  owner 'root'
  group 'root'
  mode '0444'
  variables ({
    :public_key => lazy { ::File.read(public_key_path) },
    :port => node['tinc']['listen_port'],
    :ip => node['ipaddress']
  })
end

ruby_block "set hostfile" do
  block do
    node.default['tinc']['hostfile'] = ::File.read(hostfile_path)
    node.save
  end
end

hosts_to_connect = search(:node, "tinc_network_name:#{node['tinc']['network_name']} AND chef_environment:#{node.chef_environment}")
hosts_to_connect.delete_if { |host| node['fqdn'] == host['fqdn']}

template "#{network_config_dir_path}/tinc.conf" do
  source 'tinc.config.erb'
  owner 'root'
  group 'root'
  mode '0444'
  variables ({
    :hosts => hosts_to_connect,
    :fqdn => hostname
  })
end

hosts_to_connect.each do |host|
  other_hostname = host['fqdn'].gsub(/[.\-_]+/, '')
  other_hostfile_path = "#{network_config_dir_path}/hosts/#{other_hostname}"
  file other_hostfile_path do
    owner 'root'
    group 'root'
    mode '0444'
    content host['tinc']['hostfile']
    not_if { host['tinc'].nil? || host['tinc']['hostfile'].nil? }
  end
end

file "#{network_config_dir_path}/tinc-up" do
  owner 'root'
  group 'root'
  mode '0544'
  content "#!/bin/bash\nifconfig $INTERFACE #{node['tinc']['private_ip']} netmask #{node['tinc']['netmask']}\n"
end

file "#{network_config_dir_path}/tinc-down" do
  owner 'root'
  group 'root'
  mode '0544'
  content "#!/bin/bash\nifconfig $INTERFACE down\n"
end
