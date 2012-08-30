class AddCompletedColumnToTorrents < ActiveRecord::Migration
  def change
    add_column :torrents, :completed, :integer, :default => 0
  end
end
