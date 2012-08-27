class AddTorrentIdToPeers < ActiveRecord::Migration
  def change
    add_column :peers, :torrent_id, :integer
  end
end
