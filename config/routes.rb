Rails.application.routes.draw do |map|
  resources :votes, :controller => 'we_vote/votes', :only => [:create, :update]
  resources :delegations, :controller => 'we_vote/delegations', :only => [:index, :new, :create, :show, :destroy]
end