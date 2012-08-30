class AddTorrentIdColumnToTorrentFile < ActiveRecord::Migration
  def change
    add_column :torrent_files, :torrent_id, :integer
  end
end
