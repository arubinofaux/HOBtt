class TorrentFile < ActiveRecord::Base
  belongs_to :torrent
  
  attr_accessible :filename, :files_count, :name, :size
  
  before_destroy :destroy_file
  
  private
  
  def destroy_file
    `rm #{T_SETTINGS[:torrent_file_root]}/#{self.filename}`
  end
end
