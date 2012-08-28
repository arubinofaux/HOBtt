class Torrent < ActiveRecord::Base
  attr_accessible :info_hash, :name, :description
  
  has_many :peers, :dependent => :destroy
  
  def completed
    0
  end
  
  def seeders
    Peer.all.where("torrent_id = ? AND leftt = ?", self.id, '0').count
  end
  
  def leechers
    Peer.all.where("torrent_id = ? AND leftt NOT LIKE ?", self.id, '0').count
  end
end
