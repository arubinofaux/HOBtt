class TrackerController < ApplicationController
  before_filter :get_remote_ip

  def announce
    set_vars
    
    @torrent = Torrent.find_or_create_by_info_hash(@info_hash)
    
    @torrent.completed += 1 if @event && @event == 'completed'
    @torrent.save
    
    @peer = @torrent.peers.find_by_peer_id(@peer_id)
    if @peer.nil?
      @peer = @torrent.peers.create({
        :peer_id => @peer_id,
        :ip => @remote_ip,
        :port => @port,
        :uploaded => @uploaded.to_s,
        :downloaded => @downloaded.to_s,
        :leftt => @left.to_s,
        :last_action_at => Time.now
      })
    else
      @peer.uploaded = @uploaded
      @peer.downloaded = @dowloaded
      @peer.leftt = @left
      @peer.last_action_at = Time.now
      @peer.save
    end
    
    @peers = []
    @torrent.peers.each do |peer|
      @peers << {'ip' => peer.ip, 'port' => peer.port.to_i, 'peer id' => [peer.peer_id].pack('H*')}
    end
    
    response = {
        'interval' => 900,
        'peers' => @peers
    }
    
    Rails.logger.info "\nAnnounce response to #{@remote_ip}: " + response.bencode + "\n"
    render :text => response.bencode, :content_type => "text/plain"
  end

  def scrape
    if params[:info_hash]
      @info_hash = params[:info_hash].unpack('H*')[0]
      @torrent = Torrent.find_by_info_hash(@info_hash)
      
      if @torrent.nil?
        render_error "Could not find torrent for info hash #{@info_hash}"
        return
      end
      
      @response = {
        'files' => {
          [@info_hash].pack('H*') => {
            'complete' => @torrent.seeders.count,
            'downloaded' => @torrent.completed,
            'incomplete' => @torrent.leechers.count
          }
        }
      }
    
    else
      @torrents = Torrent.all
      @files = {}
      
      @torrents.each do |torrent|
        @files[[torrent.info_hash].pack('H*')] = {
          'complete' => torrent.seeders.count,
          'downloaded' => torrent.completed,
          'incomplete' => torrent.leechers.count
        }
      end
      
      @response = {'files' => @files}
    end
    
    Rails.logger.info "\nScrape response to #{@remote_ip}: " + @response.bencode + "\n"
    render :text => @response.bencode, :content_type => "text/plain"
  end
  
  private
  
  def set_vars
    @rsize = 50
    ['num want', 'numwant', 'num_want'].each do |k|
      if params[k]
        @rsize = params[k].to_i
        break
      end
    end
    @info_hash    = params[:info_hash].unpack('H*')[0]
    @peer_id      = params[:peer_id].unpack('H*')[0]
    @port         = params[:port]
    @uploaded     = params[:uploaded].to_i
    @downloaded   = params[:downloaded].to_i
    @left         = params[:left].to_i
    @event        = params[:event]
    @seeder       = (@left == 0) ? true : false
  end
end
