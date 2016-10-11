require 'omniauth'
require 'omniauth/strategy'
module OmniAuth
  module Strategies
    class Pubcookie
      include OmniAuth::Strategy

      option :name, :pubcookie
      option :login_path, '/login'

      def request_phase
        redirect options.login_path
      end

      def callback_path
        log :error, request.env
        options.login_path
      end

    end
  end
end
