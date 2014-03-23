class CreateTruSummaries < ActiveRecord::Migration
  def self.up
    create_table :tru_summaries do |t|
    end
  end

  def self.down
    drop_table :tru_summaries
  end
end
