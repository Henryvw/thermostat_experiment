module Api
  module V1
    class ReadingsController < ActionController::API
      def create
      end

      def show
        @reading = Reading.find(params[:id])
      end

      def return_scientific_measurements
      end
    end
  end
end
