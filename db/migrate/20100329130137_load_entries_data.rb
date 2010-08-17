require 'active_record/fixtures'

class LoadEntriesData < ActiveRecord::Migration
  def self.up
    directory = File.join(File.dirname(__FILE__), 'init_data')
    Fixtures.create_fixtures(directory, "entries")
  end

  def self.down
    Entry.delete_all
  end
end
