class CreateDelegatedVotes < ActiveRecord::Migration
  def self.up
    create_table :delegated_votes do |t|
      t.integer :user_id
      t.integer :proposal_id
      t.float :value
      
      t.timestamps
    end
  end

  def self.down
    drop_table :delegated_votes
  end
end
