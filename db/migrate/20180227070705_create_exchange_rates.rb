# creating exchange rates here
class CreateExchangeRates < ActiveRecord::Migration[5.1]
  def change
    create_table :exchange_rates do |t|
      t.string :base_currency, limit: 3, null: false
      t.string :target_currency, limit: 3, null: false
      t.date :date, null: false
      t.decimal :rate, null: false
      t.decimal :prediction, null: false
      t.timestamps null: false
    end
  end
end
