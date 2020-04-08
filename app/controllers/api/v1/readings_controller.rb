module Api
  module V1
    class ReadingsController < Api::V1::BaseController
      def create
        new_reading = Reading.new(reading_params)

        if new_reading.save
          head :created
        else
          render json: { errors: new_reading.errors }, status: :bad_request
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
