class AddSummaryToProposal < ActiveRecord::Migration
  def self.up
    add_column :proposals, :summary, :text
  end

  def self.down
    remove_column :proposals, :summary
  end
end
