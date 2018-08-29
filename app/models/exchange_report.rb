# frozen_string_literal: true

class ExchangeReport < ApplicationRecord
  CURRENCIES = %w[AUD BGN BRL CAD CHF CNY CZK DKK
                  EUR GBP HKD HRK HUF IDR ILS INR JPY
                  KRW MXN MYR NOK NZD PHP PLN RON RUB
                  SEK SGD THB TRY USD ZAR].freeze

  validates_inclusion_of :amount, in: 1..1000000, message: "must be in 1 - 1000000"
  validates_inclusion_of :max_wait_time_in_weeks, in: 1..250, message: "must be in 1 - 250"

  validates_inclusion_of :base_currency, :target_currency, in: CURRENCIES, message: "not supported"
  validate :base_and_target_currency_cannot_be_same

  before_save :calculate_corresponding_future_dates
  belongs_to :user
  has_and_belongs_to_many :exchange_rates, -> { order(date: :desc) }

  def base_and_target_currency_cannot_be_same
    errors.add(:target_currency, "can't be same as base currency") if base_currency == target_currency && base_currency.present?
  end

  def collect_data
    exchange_rates.destroy_all if exchange_rates.present?

    creation_date_monday = created_at.beginning_of_week
    (max_wait_time_in_weeks + 1).times do |i|
      week_to_find = (creation_date_monday - i.weeks).strftime("%Y-%m-%d")
      exchange_rate = ExchangeRate.find_by(date: week_to_find, base_currency: base_currency, target_currency: target_currency)
      if exchange_rate.blank? # need to make api call to get data
        begin
          result = HTTParty.get "https://api.fixer.io/#{week_to_find}?base=#{base_currency}&symbols=#{target_currency}", timeout: 2
        rescue Net::OpenTimeout
          result = HTTParty.get "https://api.fixer.io/#{week_to_find}?base=#{base_currency}&symbols=#{target_currency}", timeout: 2
        end
        if result.parsed_response.include? "Too Many Requests"
          sleep 5
          result = HTTParty.get "https://api.fixer.io/#{week_to_find}?base=#{base_currency}&symbols=#{target_currency}", timeout: 2
        end
        exchange_rate = ExchangeRate.create(
          base_currency: result["base"],
          target_currency: result["rates"].first.first,
          date: week_to_find,
          rate: result["rates"].first.last
        )
      end
      exchange_rate.calculate_prediction
      exchange_rates << exchange_rate
    end
    update_columns(best_weeks_ids: calculate_best_weeks_ids)
  end

  def conversion_currencies
    "#{base_currency} -> #{target_currency}"
  end

  def target_currency_amount(rate)
    return (amount * rate.rate).round(2) if rate == exchange_rates.first
    (amount * rate.prediction).round(2)
  end

  # amount to receive if exchange money without waiting
  def amount_no_waiting
    return 0 if exchange_rates&.first&.rate.blank?
    (amount * exchange_rates&.first&.rate).round(2)
  end

  def color_class(rate)
    return "text-success" if target_currency_amount(rate) > amount_no_waiting
    return "text-danger" if target_currency_amount(rate) < amount_no_waiting
    ""
  end

  def profit_or_loss(rate)
    target_currency_amount(rate) - amount_no_waiting
  end

  def data_for_chart
    chart_data = []
    exchange_rates.each_with_index do |rate, index|
      step = []
      step << future_dates[index].strftime("%Y - %W")
      step << target_currency_amount(rate)
      chart_data << step
    end
    chart_data
  end

  def calculate_corresponding_future_dates
    self.future_dates = []
    if new_record?
      generation_date = Date.today.beginning_of_week
    else
      generation_date = created_at.beginning_of_week
    end

    future_dates << generation_date
    1.upto(max_wait_time_in_weeks) do |i|
      future_dates << generation_date + i.weeks
    end
  end

  def calculate_best_weeks_ids
    exchange_rates.sort_by { |rate| -rate.prediction }.first(3).map(&:id)
  end

  def top_three?(exchange_rate_id)
    return true if best_weeks_ids.include?(exchange_rate_id)
    false
  end

  def rank_number(exchange_rate_id)
    case exchange_rate_id
    when best_weeks_ids[0]
      1
    when best_weeks_ids[1]
      2
    when best_weeks_ids[2]
      3
    else
      ""
    end
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
#  future_dates           :date             default([]), is an Array
#  best_weeks_ids         :integer          default([]), is an Array
#
