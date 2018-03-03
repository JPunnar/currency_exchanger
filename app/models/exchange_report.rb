class ExchangeReport < ApplicationRecord
	CURRENCIES = ['AUD', 'BGN', 'BRL', 'CAD', 'CHF', 'CNY', 'CZK', 'DKK', 
    'EUR', 'GBP', 'HKD', 'HRK', 'HUF', 'IDR', 'ILS', 'INR', 'JPY', 
    'KRW', 'MXN', 'MYR', 'NOK', 'NZD', 'PHP', 'PLN', 'RON', 'RUB', 
    'SEK', 'SGD', 'THB', 'TRY', 'USD', 'ZAR'].freeze

  validates :amount, :max_wait_time_in_weeks, :base_currency, :target_currency, presence: true

  belongs_to :user
  has_many :graphs, dependent: :destroy
  has_many :exchange_rates, through: :graphs

  def collect_data
    this_monday = Date.today.beginning_of_week

    (max_wait_time_in_weeks + 1).times do |i|
      week_to_find = (this_monday - i.weeks).strftime('%Y-%m-%d')
      exchange_rate = ExchangeRate.find_by base_currency: base_currency, target_currency: target_currency, date: week_to_find
      if exchange_rate.blank? # need to make api call to get data
        result = HTTParty.get "https://api.fixer.io/#{week_to_find}?base=#{base_currency}&symbols=#{target_currency}"
        exchange_rate = ExchangeRate.create(
          base_currency: result['base'], 
          target_currency: result['rates'].first.first,
          date: result['date'],
          rate: result['rates'].first.last
        )
      end
      exchange_rates << exchange_rate
    end
  end

  def calculate

    
  end

  def conversion_currencies
    "#{base_currency} -> #{target_currency}"
  end
end

# == Schema Information
#
# Table name: exchange_reports
#
#  id                     :integer          not null, primary key
#  base_currency          :string(3)        not null
#  target_currency        :string(3)        not null
#  amount                 :decimal(, )      not null
#  max_wait_time_in_weeks :integer          not null
#  user_id                :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
