class Torrent < ActiveRecord::Base
  attr_accessible :info_hash, :name, :description
  
  has_many :peers, :dependent => :destroy
  
  def seeders
    Peer.find(:all, :conditions => ["torrent_id = ? AND left LIKE ?", self.id, "0"]).count
  end
  
  def leechers
    Peer.find(:all, :conditions => ["torrent_id = ? AND left NOT LIKE ?", self.id, "0"]).count
  end
end
