class ApplicationController < ActionController::Base
  protect_from_forgery
  
  protected
  
  def get_remote_ip
    e = request.env
    @remote_ip = e['HTTP_X_FORWARDED_FOR'] || e['HTTP_CLIENT_IP'] || e['REMOTE_ADDR'] || nil
    if @remote_ip.nil?
      render_error("Could not determine remote IP Address."); return false
    end
    return @remote_ip
  end
  
  def render_error(msg)
    render :text => error(msg)
  end
end
