Rails.application.routes.draw do |map|
  resources :votes, :controller => 'we_vote/votes', :only => [:create, :update]
end