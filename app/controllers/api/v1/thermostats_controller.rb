module Api
  module V1
    class ThermostatsController < ActionController::API
      def stats
        given_household = Thermostat.find(params[:id])
        given_household.assemble_stats(params[:start], params[:stop])
      end
    end
  end
end
