module Api
  module V1
    class ReadingsController < ActionController::API
      def create
      end

      def show
        @reading = Reading.find(params[:id])
      end
    end
  end
end
