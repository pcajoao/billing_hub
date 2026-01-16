module Api
  module V1
    class SubscriptionsController < BaseController
      def create
        subscription = Subscription.new(subscription_params)
        
        if subscription.save
          render json: subscription, status: :created
        else
          render json: { errors: subscription.errors }, status: :unprocessable_entity
        end
      end

      private

      def subscription_params
        params.require(:subscription).permit(:plan_id, :customer_id, :amount_cents, :cron_expression)
      end
    end
  end
end
