require 'csv'

namespace :migration do
  desc "Import 'De-Para' Mapping from Asaas to Pagar.me. Usage: rake migration:import_tokens[path/to/file.csv] tenant=hotel_x"
  task :import_tokens, [:file_path] => :environment do |t, args|
    file_path = args[:file_path]
    tenant_id = ENV['tenant']

    unless file_path.present? && File.exist?(file_path)
      puts "❌ Error: File not found. Usage: rake migration:import_tokens[path/to/file.csv] tenant=hotel_x"
      exit
    end

    unless tenant_id.present?
      puts "❌ Error: Tenant external_id required. Usage: ... tenant=hotel_x"
      exit
    end

    # Use Apartment to switch to the correct Tenant Schema
    unless Tenant.exists?(external_id: tenant_id)
      puts "❌ Error: Tenant '#{tenant_id}' not found."
      exit
    end

    puts "🔄 Starting Migration for Tenant: #{tenant_id}"
    
    Apartment::Tenant.switch(tenant_id) do
      success_count = 0
      error_count = 0

      CSV.foreach(file_path, headers: true) do |row|
        # CSV Expected Headers: old_token,new_token,brand,last4
        
        command = Customers::MigrateFromAsaasService.call(
          old_token: row['old_token'],
          new_token: row['new_token'],
          extra_data: {
            brand: row['brand'],
            last4: row['last4']
          }
        )

        if command.success?
          puts "✅ Updated: #{row['old_token']} -> #{row['new_token']}"
          success_count += 1
        else
          puts "⚠️ Skipped: #{row['old_token']} - #{command.errors.full_messages.join(', ')}"
          error_count += 1
        end
      end

      puts "\n🏁 Migration Finished!"
      puts "✅ Success: #{success_count}"
      puts "❌ Errors: #{error_count}"
    end
  end
end
