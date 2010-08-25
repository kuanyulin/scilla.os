require 'active_record/fixtures'

class LoadDailyRevenuesData < ActiveRecord::Migration
  def self.up
    directory = File.join(File.dirname(__FILE__), 'init_data')
    Fixtures.create_fixtures(directory, "daily_revenues")
  end

  def self.down
    DailyRevenue.delete_all
  end
end
