class Peer < ActiveRecord::Base
  attr_accessible :ip, :peer_id, :port, :uploaded, :downloaded, :left, :last_action_at
  
  belongs_to :torrent
end