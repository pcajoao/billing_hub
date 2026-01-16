module Api
  module V1
    class InvoicesController < BaseController
      def create
        invoice = Invoice.find(params[:id])
        command = Billing::ProcessInvoiceService.call(invoice)

        if command.success?
          render json: command.result, status: :ok
        else
          render json: { errors: command.errors }, status: :unprocessable_entity
        end
      end

      def show
        invoice = Invoice.find(params[:id])
        render json: invoice
      end
    end
  end
end
