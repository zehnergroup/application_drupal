#
# Cookbook Name:: application_drupal
# Resource:: drupal
#
# Copyright 2012, ZehnerGroup
#

include Chef::Resource::ApplicationBase

attribute :database_master_role, :kind_of => [String, NilClass], :default => nil
attribute :packages, :kind_of => [Array, Hash], :default => []
attribute :app_root, :kind_of => String, :default => "/"

attribute :settings_file, :kind_of => [String, NilClass], :default => 'settings.php'
# Actually defaults to "#{settings_file_name}.erb", but nil means it wasn't set by the user
attribute :settings_template, :kind_of => [String, NilClass], :default => nil
attribute :settings_template_on_repo, :kind_of => [TrueClass, FalseClass], :default => false

def settings_file_name
  @settings_file_name ||= settings_file.split(/[\\\/]/).last
end

attribute :sass_config_file, :kind_of => [String, NilClass], :default => 'config.rb'
# Actually defaults to "#{sass_config_file_name}.erb", but nil means it wasn't set by the user
attribute :sass_config_template, :kind_of => [String, NilClass], :default => nil
attribute :sass_config_template_on_repo, :kind_of => [TrueClass, FalseClass], :default => false

def sass_config_file_name
  @sass_config_file_name ||= sass_config_file.split(/[\\\/]/).last
end

attribute :setup_file, :kind_of => [String, NilClass], :default => 'setup.php'
# Actually defaults to "#{setup_file_name}.erb", but nil means it wasn't set by the user
attribute :setup_template, :kind_of => [String, NilClass], :default => nil
attribute :setup_template_on_repo, :kind_of => [TrueClass, FalseClass], :default => false

attribute :server_environment, :kind_of => [String, NilClass], :default => nil

def setup_file_name
  @setup_file_name ||= setup_file.split(/[\\\/]/).last
end

def database(*args, &block)
  @database ||= Mash.new
  @database.update(options_block(*args, &block))
end