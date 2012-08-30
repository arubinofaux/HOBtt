class Torrent < ActiveRecord::Base
  attr_accessible :info_hash, :name, :description
  
  has_many :peers, :dependent => :destroy
  
  def seeders
    self.peers.where("leftt = ?", '0')
  end
  
  def leechers
    self.peers.where("leftt NOT LIKE ?", '0')
  end
end
