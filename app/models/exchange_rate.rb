class ExchangeRate < ApplicationRecord
  has_many :exchange_reports, through: :graphs
end

# == Schema Information
#
# Table name: exchange_rates
#
#  id              :integer          not null, primary key
#  base_currency   :string(3)        not null
#  target_currency :string(3)        not null
#  date            :date             not null
#  rate            :decimal(, )      not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
