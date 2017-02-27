require 'redmine'

require_dependency 'projects_controller_patch'

# RAILS_DEFAULT_LOGGER.info 'Starting Redmine Desktop Client Service plugin'

Redmine::Plugin.register :redmine_desktop_client_service do
  name 'Redmine Desktop Client Service plugin'
  author 'Tamás Futó'
  description 'This is a plugin for serving data to Redmine Desktop Client via Redmine\'s rest api'
  version '0.0.1'
  url 'http://github.com/futaz/redmine_desktop_client_service'
  author_url 'http://github.com/futaz'

  permission :use_redmine_client, :projects => :status_transitions
end
