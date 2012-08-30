class Torrent < ActiveRecord::Base
  attr_accessible :info_hash, :name, :description, :completed
  
  has_many :peers, :dependent => :destroy
  has_one :torrent_file, :dependent => :destroy
  
  def seeders
    self.peers.where("leftt = ?", 0)
  end
  
  def leechers
    self.peers.where("leftt > ?", 0)
  end
end
