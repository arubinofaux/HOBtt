class TorrentFile < ActiveRecord::Base
  belongs_to :torrent
  
  attr_accessible :filename, :files_count, :name, :size
  attr_accessor :torrent_data
  
  before_save do |tf|
    @torrent_data = tf.torrent_data
  end
  
  after_save do
    file_path = File.join T_SETTINGS[:torrent_file_root], self.filename
    @torrent_data['comment'] = T_SETTINGS[:torrent_comment]
    File.open(file_path, 'wb') do |f|
      f.write(@torrent_data.bencode)
    end
  end
  
  before_destroy :destroy_file
  
  private
  
  def destroy_file
    `rm #{T_SETTINGS[:torrent_file_root]}/#{self.filename}`
  end
end
