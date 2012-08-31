class TorrentFilesController < ApplicationController
  require 'digest/sha1'
  TORRENT_FILES_ROOT = File.join Rails.public_path, 'torrent_files'

  def index
    @torrent_files = TorrentFile.all(:order => "name DESC")
  end
  
  def new
  end

  def upload
    @torrent_file = TorrentFile.new
    
    temp_data = params[:file]
    raise InvalidFileTypeError.new("Not a torrent file!") unless temp_data.content_type == "application/x-bittorrent"
    
    original_filename = temp_data.original_filename
    torrent_file_data = temp_data.read
    
    torrent_data = BEncode.load(torrent_file_data)
    info_hash = Digest::SHA1.hexdigest torrent_data['info'].bencode
    
    torrent = Torrent.find_by_info_hash(info_hash)
    
    @torrent_file.filename = original_filename
    @torrent_file.name = torrent_data['info']['name']
    @torrent_file.size, @torrent_file.files_count = file_size_and_count(torrent_data)
    @torrent_file.torrent_id = torrent.id unless torrent.nil?
    
    if @torrent_file.save
      filename = File.join TORRENT_FILES_ROOT, original_filename
      File.open(filename, 'wb') do |f|
        f.write(torrent_file_data)
      end
      
      redirect_to :root
    end
  end
  
  def download
    filename = TorrentFile.find(params[:id]).filename
    send_file(File.join(TORRENT_FILES_ROOT, filename), :type => :torrent)
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
