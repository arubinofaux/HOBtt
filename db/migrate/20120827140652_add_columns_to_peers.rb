class AddColumnsToPeers < ActiveRecord::Migration
  def change
    add_column :peers, :uploaded, :integer
    add_column :peers, :downloaded, :integer
    add_column :peers, :left, :integer
    add_column :peers, :last_action_at, :datetime
  end
end
