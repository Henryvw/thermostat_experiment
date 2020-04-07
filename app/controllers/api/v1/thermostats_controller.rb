module Api
  module V1
    class ThermostatsController < ActionController::API
      def stats
        household = Thermostat.find(params[:id])
        @household_stats_for_timeframe = household.assemble_stats(params[:start], params[:stop])
      end
    end
  end
end
