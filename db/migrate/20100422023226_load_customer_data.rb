require 'active_record/fixtures'

class LoadCustomerData < ActiveRecord::Migration
  def self.up
    directory = File.join(File.dirname(__FILE__), 'init_data')
    Fixtures.create_fixtures(directory, "customers")
  end

  def self.down
    Customer.delete_all
  end
end
