module WeVote
  class Delegation < ActiveRecord::Base
    validates_uniqueness_of :delegated_id, :scope => [:delegatee_id, :theme_id]
  end
end