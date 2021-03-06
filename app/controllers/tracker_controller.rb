class TrackerController < ApplicationController
  before_filter :get_remote_ip

  def announce
    set_vars
    
    @torrent = Torrent.find_or_create_by_info_hash(@info_hash)
    
    @torrent.completed += 1 if @event == 'completed'
    @torrent.save
    
    @peer = @torrent.peers.find_by_peer_id(@peer_id)
    if @peer.nil?
      @peer = @torrent.peers.create({
        :peer_id => @peer_id,
        :ip => @remote_ip,
        :port => @port,
        :uploaded => @uploaded,
        :downloaded => @downloaded,
        :leftt => @left,
        :last_action_at => Time.now
      })
    elsif @event == 'stopped'
      @peer.destroy
      render :nothing => true
      return
    else
      @peer.uploaded = @uploaded
      @peer.downloaded = @downloaded
      @peer.leftt = @left
      @peer.last_action_at = Time.now
      @peer.save
    end
    
    if @compact
      @peers = ""
      @torrent.peers.all(:limit => @numwant).each do |peer|
        @peers << peer.compact_ip
      end
    else
      @peers = []
      @torrent.peers.all(:limit => @numwant).each do |peer|
        @peers << {'ip' => peer.ip, 'port' => peer.port, 'peer id' => [peer.peer_id].pack('H*')}
      end
    end
    
    response = {
        'interval' => T_SETTINGS[:announce_interval],
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
        failure_response "Could not find torrent for info hash #{@info_hash}"
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
    @numwant = 50
    ['num want', 'numwant', 'num_want'].each do |k|
      if params[k]
        @numwant = params[k].to_i
        break
      end
    end
    @info_hash    = params[:info_hash].unpack('H*')[0]
    @peer_id      = params[:peer_id].unpack('H*')[0]
    @port         = params[:port].to_i
    @uploaded     = params[:uploaded].to_i
    @downloaded   = params[:downloaded].to_i
    @left         = params[:left].to_i
    @event        = params[:event]
    @compact      = params[:compact].to_i
  end
end
