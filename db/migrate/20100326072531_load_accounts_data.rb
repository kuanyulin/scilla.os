require 'active_record/fixtures'

class LoadAccountsData < ActiveRecord::Migration
  def self.up
    directory = File.join(File.dirname(__FILE__), 'init_data')
    Fixtures.create_fixtures(directory, "accounts")
  end

  def self.down
    Account.delete_all
  end
end
