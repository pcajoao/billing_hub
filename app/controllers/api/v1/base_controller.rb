module Api
  module V1
    class BaseController < ApplicationController
      rescue_from ActiveRecord::RecordNotFound, with: :not_found
      rescue_from StandardError, with: :internal_server_error

      private

      def not_found(exception)
        render json: { error: exception.message }, status: :not_found
      end

      def internal_server_error(exception)
        Rails.logger.error(exception)
        render json: { error: "Internal Server Error" }, status: :internal_server_error
      end
    end
  end
end
