class AddColumnsToPeers < ActiveRecord::Migration
  def change
    add_column :peers, :uploaded, :string
    add_column :peers, :downloaded, :string
    add_column :peers, :left, :string
    add_column :peers, :last_action_at, :datetime
  end
end
