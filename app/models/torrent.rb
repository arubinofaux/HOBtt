class Torrent < ActiveRecord::Base
  attr_accessible :info_hash, :name, :description, :completed
  
  with_options :dependent => :destroy do |i|
    i.has_many :peers
    i.has_one :torrent_file
  end
  
  def seeders
    self.peers.where("leftt = ?", 0)
  end
  
  def leechers
    self.peers.where("leftt > ?", 0)
  end
end
