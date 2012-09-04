#
# The global tracker and torrent file settings should go here
#

T_SETTINGS = {
  :announce_interval => 600, #seconds
  :torrent_comment => "Downloaded from HOBtt",
  :torrent_file_root => "#{File.join Rails.public_path, 'torrent_files'}"
}
