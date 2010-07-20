class DelegationsController < ApplicationController
  
  def index
    @delegations = current_user.delegations.all(:include => :delegated)
  end
  
end