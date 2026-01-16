module Api
  module V1
    class CustomersController < BaseController
      def show
        customer = Customer.find(params[:id])
        render json: customer
      end

      def create
        customer = Customer.new(customer_params)
        if customer.save
          render json: customer, status: :created
        else
          render json: { errors: customer.errors }, status: :unprocessable_entity
        end
      end

      def migrate
        command = Customers::MigrateFromAsaasService.call(params[:asaas_id])
        
        if command.success?
          render json: { message: "Migration started" }, status: :accepted
        else
          render json: { errors: command.errors }, status: :unprocessable_entity
        end
      end

      private

      def customer_params
        params.require(:customer).permit(:name, :email, :doc_type, :doc_number)
      end
    end
  end
end
