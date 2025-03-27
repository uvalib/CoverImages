# ApplicationController
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def after_sign_in_path_for(_resource)
    root_path
  end

  private
  def append_info_to_payload(payload)
    super
    payload.merge!(remote_ip: request.remote_ip)
  end
end
