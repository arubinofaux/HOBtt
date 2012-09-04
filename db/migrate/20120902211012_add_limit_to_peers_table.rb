class AddLimitToPeersTable < ActiveRecord::Migration
  def change
    change_column :peers, :downloaded, :integer, :limit => 8
    change_column :peers, :uploaded, :integer, :limit => 8
    change_column :peers, :leftt, :integer, :limit => 8
  end
end
