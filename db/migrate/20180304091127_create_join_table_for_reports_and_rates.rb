class CreateJoinTableForReportsAndRates < ActiveRecord::Migration[5.1]
  def change
    create_table :exchange_rates_reports, id: false do |t|
      t.belongs_to :exchange_rate, null: false, index: true
      t.belongs_to :exchange_report, null: false, index: true
    end
  end
end
