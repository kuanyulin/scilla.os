require 'active_record/fixtures'

class LoadJournalsData < ActiveRecord::Migration
  def self.up
    directory = File.join(File.dirname(__FILE__), 'init_data')
    Fixtures.create_fixtures(directory, "journals")
  end

  def self.down
    Journal.delete_all
  end
end
