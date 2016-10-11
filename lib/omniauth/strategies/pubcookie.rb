require 'omniauth'
require 'omniauth/strategy'
module OmniAuth
  module Strategies
    class Pubcookie
      include OmniAuth::Strategy

      option :name, :pubcookie
      option :callback_path, '/users/auth/pubcookie/callback'
      option :request_path, '/users/auth/pubcookie'

      def request_phase
        log :info, "######## PUBCOOKIE REQUEST ######"
        redirect options.callback_path
      end

      def callback_phase
        log :info, "######## PUBCOOKIE CALLBACK ######"
        log :info, request.env
      end


    end
  end
end
