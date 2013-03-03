#
# Cookbook Name:: application_drupal
# Provider:: drupal
#
# Copyright 2012, ZehnerGroup
#
#

include Chef::Mixin::LanguageIncludeRecipe

action :before_compile do

  include_recipe 'php'

  new_resource.symlink_before_migrate.update({
    new_resource.settings_file_name => new_resource.settings_file,
    new_resource.setup_file_name => new_resource.setup_file,
    new_resource.sass_config_file_name => new_resource.sass_config_file,
  })

end

action :before_deploy do

  install_packages

end

action :before_migrate do

  create_settings_files

end

action :before_symlink do
end

action :before_restart do
end

action :after_restart do
end

protected

def install_packages
  new_resource.packages.each do |name,ver|
    php_pear name do
      action :install
      version ver if ver && ver.length > 0
    end
  end
end

def create_settings_files

  # Create main Drupal settings.php file
  template ::File.join(new_resource.path, 'shared', new_resource.settings_file_name) do
    if (new_resource.settings_template_on_repo)
      settings_template = ::File.join(new_resource.release_path, new_resource.settings_template)
    else
      settings_template = new_resource.settings_template || "#{new_resource.settings_file_name}.erb"
    end
    Chef::Log.info("Environment: #{new_resource.server_environment}")
    source settings_template
    local new_resource.settings_template_on_repo
    owner new_resource.owner
    group new_resource.group
    mode "644"
    variables({
      :path => "#{new_resource.path}/current",
      :environment => new_resource.server_environment,
      :database => new_resource.database
    })
  end

  # Create Drupal setup.php file
  template ::File.join(new_resource.path, 'shared', new_resource.setup_file_name) do
    if (new_resource.setup_template_on_repo)
      setup_template = ::File.join(new_resource.release_path, new_resource.setup_template)
    else
      setup_template = new_resource.setup_template || "#{new_resource.setup_file_name}.erb"
    end
    source setup_template
    local new_resource.setup_template_on_repo
    owner new_resource.owner
    group new_resource.group
    mode "644"
    variables({ :environment => new_resource.server_environment })
  end

  # Create SASS config.rb file
  template ::File.join(new_resource.path, 'shared', new_resource.sass_config_file_name) do
    if (new_resource.sass_config_template_on_repo)
      sass_config_template = ::File.join(new_resource.release_path, new_resource.sass_config_template)
    else
      sass_config_template = new_resource.sass_config_template || "#{new_resource.sass_config_file_name}.erb"
    end
    source sass_config_template
    local new_resource.sass_config_template_on_repo
    owner new_resource.owner
    group new_resource.group
    mode "644"
    variables({ :environment => new_resource.server_environment })
  end

end