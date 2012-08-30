class TorrentFilesController < ApplicationController
  def index
    @torrent_files = TorrentFile.all(:order => "name DESC")
  end

  def upload
    @torrent_file_data = params[:torrent_file][:file]
    @torrent_file = TorrentFile.new
    
    if @torrent_file.save
      redirect_to :index
    end
  end
  
  def download
    filename = TorrentFile.find(params[:id]).filename
    send_file(File.join(TORRENT_FILES_ROOT, filename), :type => :torrent)
  end
end
