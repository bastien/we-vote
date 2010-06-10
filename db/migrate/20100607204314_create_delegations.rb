class CreateDelegations < ActiveRecord::Migration
  def self.up
    create_table :delegations do |t|
      t.integer :delegatee_id
      t.integer :delegated_id
      t.integer :theme_id

      t.timestamps
    end
  end

  def self.down
    drop_table :delegations
  end
end
