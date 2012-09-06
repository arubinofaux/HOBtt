class Peer < ActiveRecord::Base
  require 'ipaddr'
  
  attr_accessible :ip, :peer_id, :port, :uploaded, :downloaded, :leftt, :last_action_at
  
  belongs_to :torrent
  
  def self.destroy_inactive
    destroy_all("last_action_at < '#{15.minutes.ago.to_formatted_s(:db)}'")
  end
  
  def compact_ip(ip = self.ip, port = self.port)
    ipaddr = IPAddr.new ip
    if ipaddr.ipv4?
      compact_ip = ipaddr.hton
      p = port
      compact_port = ''
      until p == 0
        compact_port << (p & 0xFF).chr
        p >>= 8
      end
      compact_ip << compact_port.reverse
    end
  end
end
