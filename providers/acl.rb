#
# Author:: Cameron Johnston (cameron@needle.com)
# Cookbook Name:: zncrypt
# Provider:: acl
#
# Copyright 2012, Needle, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

action :add do

  license_data = load_license(@new_resource.data_bag,node['hostname'])

  if license_data['passphrase']
    auth_args = "#{new_resource.permission} @#{@new_resource.category} #{@new_resource.path} #{@new_resource.process} -P #{license_data['passphrase']}}"
    if license_data['salt']
      auth_args + " -S #{license_data['salt']}"
    end
    unless @new_resource.executable.nil?
      rule_args + " --exec=#{@new_resource.executable}"
    end
    unless @new_resource.children.nil?
      rule_args + " --children=#{@new_resource.children}"
    end
    cmd_args = "#{auth_args} -a \"#{rule_args}\""
  else
    Chef::Log.fatal("zncrypt acl: failed to load passphrase from license data from the #{@new_resource.data_bag}, cannot proceed")
    raise
  end

  execute "#{@new_resource.permission} #{@new_resource.path} for #{@new_resource.process} in category #{@new_resource.category}" do
    command "ezncrypt-access-control #{cmd_args}"
    action :run
    returns [0,1]
  end
end

action :remove do

  license_data = load_license(@new_resource.data_bag,node['hostname'])

  if license_data['passphrase']
    auth_args = "#{new_resource.permission} @#{@new_resource.category} #{@new_resource.path} #{@new_resource.process} -P #{license_data['passphrase']}}"
    if license_data['salt']
      auth_args + " -S #{license_data['salt']}"
    end
    unless @new_resource.executable.nil?
      rule_args + " --exec=#{@new_resource.executable}"
    end
    unless @new_resource.children.nil?
      rule_args + " --children=#{@new_resource.children}"
    end
    cmd_args = "#{auth_args} -a \"#{rule_args}\""
  else
    Chef::Log.fatal("zncrypt acl: failed to load passphrase from license data from the #{@new_resource.data_bag}, cannot proceed")
    raise
  end

  execute "#{@new_resource.permission} #{@new_resource.path} for #{@new_resource.process} in category #{@new_resource.category}" do
    command "ezncrypt-access-control #{cmd_args}"
    action :run
    returns [0,1]
  end
end
