class CreateGraphs < ActiveRecord::Migration[5.1]
  def change
    create_table :graphs do |t|
    	t.integer :exchange_report_id
      t.integer :exchange_rate_id
    end
  end
end
