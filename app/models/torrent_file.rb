class TorrentFile < ActiveRecord::Base  
  belongs_to :torrent
  
  attr_accessible :filename, :files_count, :name, :size
end
