class AddColumnsToTorrents < ActiveRecord::Migration
  def change
      add_column :torrents, :name, :string
      add_column :torrents, :description, :string
  end
end
