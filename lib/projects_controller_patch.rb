require_dependency 'projects_controller'

module ProjectsControllerPatch
  def self.included(base) # :nodoc:
    base.extend(ClassMethods)
    base.send(:include, InstanceMethods)
    base.class_eval do
      unloadable

      self::accept_api_auth_actions << :status_transitions
    end
  end

  module ClassMethods
  end

  module InstanceMethods

    def status_transitions
      logger.info '*** hello status_transitions'
      logger.info '*** end'
      render :json => "hello status_transition\n"
    end

  end
end

ProjectsController.send(:include, ProjectsControllerPatch)