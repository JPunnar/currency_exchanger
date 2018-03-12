class AddMulticolumnIndexToRates < ActiveRecord::Migration[5.1]
  def change
    add_index :exchange_rates, [:date, :base_currency, :target_currency], name: "rates_multicolumn_index"
  end
end
