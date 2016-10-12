class Users::SessionsController < Devise::SessionsController
# before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
   def new
     if authorized_user?
       create
     else
       flash[:notice] = "Invalid user"
       render :new
     end
   end

   # POST /resource/sign_in
   def create
     self.resource = warden.authenticate!(auth_options)
     set_flash_message(:notice, :signed_in) if is_flashing_format?
     sign_in(resource_name, resource)
     yield resource if block_given?
     redirect_to after_sign_in_path_for(resource)
   end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
  private

  def authorized_user?
    user = request.env['HTTP_REMOTE_USER']
    logger.info "--------- #{request.env} ------"
    if user.present?
      Rails.configuration.authorized_users.include? user
    elsif Rails.env.development?
      false #request.env['HTTP_REMOTE_USER'] = 'dev'
    else
      false
    end
  end
end
