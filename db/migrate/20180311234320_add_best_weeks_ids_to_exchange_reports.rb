class AddBestWeeksIdsToExchangeReports < ActiveRecord::Migration[5.1]
  def change
    add_column :exchange_reports, :best_weeks_ids, :integer, array: true, default: []
  end
end
