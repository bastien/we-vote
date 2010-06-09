class CreateDelegatedVotes < ActiveRecord::Migration
  def self.up
    create_table :delegated_votes do |t|
      t.integer :user_id
      t.float :current_value
      t.float :last_increment
      t.float :last_value
      t.boolean :affected, :default => true
      t.boolean :last_affected, :default => false
      
      t.timestamps
    end
  end

  def self.down
    drop_table :delegated_votes
  end
end
