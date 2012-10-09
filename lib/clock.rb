require File.expand_path('config/boot')
require File.expand_path('config/environment')
require 'delayed_job'

module Clockwork
  handler do |job|
    puts "Running #{job}"
  end
  
  every(15.minutes, 'peer.destroy_inactive') { Peer.delay.destroy_inactive }
end
