class ApplicationController < ActionController::Base
  protect_from_forgery
  
  class InvalidFileTypeError < StandardError; end
  
  rescue_from InvalidFileTypeError do |e|
    redirect_to :root, :alert => e.message
  end
  
  protected
  
  def get_remote_ip
    e = request.env
    @remote_ip = e['HTTP_X_FORWARDED_FOR'] || e['HTTP_CLIENT_IP'] || e['REMOTE_ADDR'] || nil
    if @remote_ip.nil?
      render_error("Could not determine remote IP Address."); return false
    end
    return @remote_ip
  end
  
  def failure_response(msg)
    render :text => {"failure reason" => "#{msg}"}.bencode, :content_type => "text/plain"
  end
  
  def sanitize_filename(filename)
    filename.strip
    filename.gsub! /.torrent$/, ''
    filename.gsub! /[^\w]/, '_'
    filename + '.torrent'
  end
end
