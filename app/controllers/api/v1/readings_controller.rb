module Api
  module V1
    class ReadingsController < Api::V1::BaseController
      def create
        if ReadingWorker.perform_async(reading_params.to_h)
          head :accepted
        else
          head :bad_request
        end
      end

      def show
        @reading = Reading.find(params[:id])
      end

      private
      def reading_params
        params.permit(:thermostat_id,
                      :temperature,
                      :humidity,
                      :battery_charge)
      end
    end
  end
end
