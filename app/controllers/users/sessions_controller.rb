class Users::SessionsController < Devise::SessionsController
# before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
   def new
     if request.env['HTTP_REMOTE_USER'].present?
       create
     else
       logger.info request.env
       self.resource = resource_class.new(sign_in_params)
       clean_up_passwords(resource)
       yield resource if block_given?
       flash[:notice] = "Invalid user"
       respond_with(resource, serialize_options(resource))
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
end
