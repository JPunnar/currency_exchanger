class CreateExchangeReports < ActiveRecord::Migration[5.1]
  def change
    create_table :exchange_reports do |t|
      t.string :base_currency, limit: 3, null: false
      t.string :target_currency, limit: 3, null: false
      t.decimal :amount, null: false
      t.integer :max_wait_time_in_weeks, null: false
      t.integer :user_id
      t.timestamps null: false    	
    end
  end
end
