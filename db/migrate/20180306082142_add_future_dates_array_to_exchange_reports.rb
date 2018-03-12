class AddFutureDatesArrayToExchangeReports < ActiveRecord::Migration[5.1]
  def change
    add_column :exchange_reports, :future_dates, :date, array: true, default: []
  end
end
