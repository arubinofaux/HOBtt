class TorrentFile < ActiveRecord::Base
  require 'digest/sha1'

  TORRENT_FILES_ROOT = File.join Rails.public_path, 'torrent_files'
  
  belongs_to :torrent
  
  attr_accessible :filename, :files_count, :name, :size
  
  before_save :find_torrent
  after_save :save_torrent_file
  
  private
  
  def find_torrent
    torrent_data = BEncode.load(@torrent_file_data)
    info_hash = Digest::SHA1.hexdigest torrent_data['info'].bencode
    
    torrent = Torrent.find_by_info_hash(info_hash)
    
    self.filename = @torrent_file_data.original_filename
    self.name = torrent_data['info']['name']
    self.torrent_id = torrent.id unless torrent.nil?
  end
  
  def save_torrent_file
    if @torrent_file_data    
      filename = File.join TORRENT_FILES_ROOT, self.filename
      File.open(filename, 'wb') do |f|
        f.write(@torrent_file_data.read)
      end
    end
  end
end
