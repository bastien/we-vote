class CreateProposals < ActiveRecord::Migration
  def self.up
    create_table :proposals do |t|
      t.string :title
      t.integer :author_id
      t.integer :theme_id

      t.timestamps
    end
  end

  def self.down
    drop_table :proposals
  end
end
