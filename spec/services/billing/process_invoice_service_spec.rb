require 'rails_helper'


RSpec.describe Billing::ProcessInvoiceService do
  let(:product) { create(:product) }

  let(:tenant) { create(:tenant) }
  let(:customer) { create(:customer, tenant: tenant) }
  let!(:payment_method) { create(:payment_method, customer: customer, is_default: true) }
  let(:invoice) { create(:invoice, customer: customer, product: product, total_amount_cents: 10000) }

  subject { described_class.call(invoice) }

  # IMPORTANT: We must ensure we are in the correct Tenant Schema for the Invoice to exist!
  # But wait, Invoice is Tenant-scoped? Yes (by schema).
  # We need to switch to tenant schema before creating invoice/customer.
  
  around do |example|
    # Ensure tenant exists and schema is created
    Apartment::Tenant.create(tenant.external_id) rescue nil 
    Apartment::Tenant.switch(tenant.external_id) do
      example.run
    end
    Apartment::Tenant.drop(tenant.external_id)
  end

  describe '#call' do
      before do
        allow(Gateways::Fake::Charge).to receive(:call).and_return(
          double(
            success?: true, 
            result: {
              success: true,
              tid: 'tid_12345',
              status: 'paid',
              error_message: nil
            },
            errors: double(full_messages: [])
          )
        )
      end

      it 'marks invoice as paid' do
        command = subject
        expect(command).to be_success
        expect(invoice.reload.status).to eq('paid')
      end

      it 'creates a success transaction' do
        subject
        transaction = invoice.transactions.last
        expect(transaction.status).to eq('paid')
        expect(transaction.gateway_id).to eq('tid_12345')
      end


    context 'when payment is refused (Insufficient Funds)' do
      before do
        allow(Gateways::Fake::Charge).to receive(:call).and_return(
          double(
            success?: true,
            result: {
              success: false,
              tid: 'tid_failed_99',
              status: 'refused',
              error_message: 'Insufficient funds'
            },
            errors: double(full_messages: ["Payment failed: Insufficient funds"])
          )
        )
      end

      it 'keeps invoice as pending (or marks failed depending on logic)' do
        subject
        expect(invoice.reload.status).to eq('pending')
      end

      it 'creates a refused transaction' do
        subject
        transaction = invoice.transactions.last
        expect(transaction.status).to eq('refused')
        expect(transaction.gateway_response_message).to eq('Insufficient funds')
      end

      it 'returns error in command' do
        command = subject
        expect(command).to be_failure
        expect(command.errors[:base]).to include("Payment failed: Insufficient funds")
      end
    end

    context 'when Gateway Times Out (Network Error)' do
      before do
        allow(Gateways::Fake::Charge).to receive(:call).and_raise(StandardError, "Gateway Timeout")
      end

      it 'handles exception gracefully' do
        expect { subject }.to raise_error(StandardError, "Gateway Timeout")
      end
    end
  end
end
