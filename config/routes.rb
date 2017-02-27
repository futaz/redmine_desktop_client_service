# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html
get 'projects/:id/status_transitions', :to => 'projects#status_transitions'