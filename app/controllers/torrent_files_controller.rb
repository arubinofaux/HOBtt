class TorrentFilesController < ApplicationController
  require 'digest/sha1'

  def index
    @torrent_files = TorrentFile.all(:order => "name")
  end
  
  def new
  end

  def upload
    @torrent_file = TorrentFile.new
    
    temp_data = params[:file]
    raise InvalidFileTypeError.new "Not a torrent file!" unless temp_data.content_type == "application/x-bittorrent"
    
    sanitized_filename = sanitize_filename(temp_data.original_filename)
    torrent_file_data = temp_data.read
    
    torrent_data = BEncode.load(torrent_file_data)
    info_hash = Digest::SHA1.hexdigest torrent_data['info'].bencode
    
    torrent = Torrent.find_by_info_hash(info_hash)
    if torrent.nil?
      redirect_to :root, :alert => "Could not find torrent with info hash #{info_hash}"
      return
    end
    
    @torrent_file.filename = sanitized_filename
    @torrent_file.name = torrent_data['info']['name']
    @torrent_file.size, @torrent_file.files_count = file_size_and_count(torrent_data)
    @torrent_file.torrent = torrent
    
    if @torrent_file.save
      filename = File.join T_SETTINGS[:torrent_file_root], sanitized_filename
      torrent_data['comment'] = T_SETTINGS[:torrent_comment]
      File.open(filename, 'wb') do |f|
        f.write(torrent_data.bencode)
      end
      
      redirect_to :root
    end
  end
  
  def download
    filename = TorrentFile.find(params[:id]).filename
    send_file(File.join(T_SETTINGS[:torrent_file_root], filename), :type => :torrent)
  end
  
  private
  
  def file_size_and_count(data)
    size = 0
    count = 0
    if data['info']['files']
      data['info']['files'].each do |f|
        size += f['length']
        count += 1
      end
    else
      size = data['info']['length']
      count = 1
    end
    [size, count]
  end
end
