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
      roles = User.current.admin ? Role.all : User.current.roles_for_project(@project)
      transitions = {}
      @project.trackers.each do |tracker|
        tracker_id = tracker.id
        transitions[tracker_id] = {}
        transitions[tracker_id][:initial_statuses] = IssueStatus.new_statuses_allowed(nil, roles, tracker).sort_by(&:position).map(&:id)
        transitions[tracker_id][:default_status] = tracker.default_status ? tracker.default_status.id : nil
        available_statuses = tracker.issue_statuses
        [[false, false], [true, true], [false, true], [true, false]].each do |creator, assignee|
          ca_key = "#{creator ? '+' : '-'}c#{assignee ? '+' : '-'}a"
          transitions[tracker_id][ca_key] = {}
          available_statuses.each do |old_status|
            allowed_statuses = IssueStatus.new_statuses_allowed(old_status, roles, tracker, creator, assignee)
            allowed_status_ids = allowed_statuses.sort_by( &:position ).map( &:id )
            transitions[tracker_id][ca_key][old_status.id] = allowed_status_ids
          end
        end
      end
      render :json => transitions
    end

  end
end

ProjectsController.send(:include, ProjectsControllerPatch)
