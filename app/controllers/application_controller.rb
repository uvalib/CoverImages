# ApplicationController
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_raven_context

  def after_sign_in_path_for(_resource)
    root_path
  end

  private

  def set_raven_context
    Raven.extra_context(url: request.url, params: params.to_unsafe_h)
  end

  def set_raven_user
    Raven.user_context(id: current_user.id, email: current_user.email) if current_user
  end

end
