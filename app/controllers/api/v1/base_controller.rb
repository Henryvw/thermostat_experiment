module Api
  module V1
    class BaseController < ApplicationController
      before_action :authenticate

      private
      # For a real / production app I would use OAuth 2 / a safer authentication system
      def authenticate
        binding.pry
        authenticate_or_request_with_http_token do |household_token, options|
          Thermostat.find_by(token: household_token)
        end
      end

      def current_thermostat
        @current_thermostat ||= authenticate
      end
    end
  end
end
