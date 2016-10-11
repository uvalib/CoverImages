require 'omniauth'
require 'omniauth/strategy'
module OmniAuth
  module Strategies
    class Pubcookie
      include OmniAuth::Strategy

      option :name, :pubcookie
      option :login_path, '/login'

      def request_phase
        log :info, "######## PUBCOOKIE REQUEST ######"
        redirect options.login_path
      end

      def callback_phase
        log :info, "######## PUBCOOKIE CALLBACK ######"
        log :info, request.env
      end


    end
  end
end
