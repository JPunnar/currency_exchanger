# frozen_string_literal: true

class ExchangeReport < ApplicationRecord
  CURRENCIES = %w[AUD BGN BRL CAD CHF CNY CZK DKK
                  EUR GBP HKD HRK HUF IDR ILS INR JPY
                  KRW MXN MYR NOK NZD PHP PLN RON RUB
                  SEK SGD THB TRY USD ZAR].freeze

  validates :amount, :max_wait_time_in_weeks, :base_currency, :target_currency, presence: true
  validates_inclusion_of :max_wait_time_in_weeks, in: 1..250, message: "is too big or too small"
  validates_inclusion_of :amount, in: 1..1000000, message: "is too big or too small"
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
      exchange_rate = ExchangeRate.find_by base_currency: base_currency, target_currency: target_currency, date: week_to_find
      if exchange_rate.blank? # need to make api call to get data
        result = HTTParty.get "https://api.fixer.io/#{week_to_find}?base=#{base_currency}&symbols=#{target_currency}"
        exchange_rate = ExchangeRate.create(
          base_currency: result["base"],
          target_currency: result["rates"].first.first,
          date: week_to_find,
          rate: result["rates"].first.last
        )
      end
      exchange_rates << exchange_rate
    end
  end

  def conversion_currencies
    "#{base_currency} -> #{target_currency}"
  end

  def target_currency_amount(rate)
    (amount * rate.prediction).round(2)
  end

  # amount to receive if exchange money without waiting
  def amount_no_waiting
    (amount * exchange_rates.first.prediction).round(2)
  end

  def color_class(rate)
    return 'text-success' if target_currency_amount(rate) > amount_no_waiting
    return 'text-danger' if target_currency_amount(rate) < amount_no_waiting
    ''
  end

  def profit_or_loss(rate)
    target_currency_amount(rate) - amount_no_waiting
  end

  def data_for_chart
    chart_data = []
    exchange_rates.each_with_index do |rate, index|
      step = []
      step << future_dates[index].strftime('%Y - %W')
      step << target_currency_amount(rate)
      chart_data << step
    end
    chart_data
  end

  def data_for_chart_baseline
    chart_data = []
    future_dates.each do |future_date|
      step = []
      step << future_date.strftime('%Y - %W')
      step << amount_no_waiting
      chart_data << step
    end
    chart_data
  end

  def calculate_corresponding_future_dates
    self.future_dates = []
    generation_date = created_at&.beginning_of_week || Date.today.beginning_of_week
    future_dates << generation_date
    1.upto(max_wait_time_in_weeks) do |i|
      future_dates << generation_date + i.weeks
    end
  end

  def find_ids_of_best_weeks
    exchange_rates.sort_by { |rate| -rate.prediction}.first(3).map(&:id)
  end

  def rank_class(exchange_rate_id)
    top_ids = find_ids_of_best_weeks
    case exchange_rate_id
    when top_ids[0]
      return 'rank-first'
    when top_ids[1]
      return 'rank-second'
    when top_ids[2]
      return 'rank-third'
    else
      return ''
    end
  end

  def rank_number(exchange_rate_id)
    top_ids = find_ids_of_best_weeks
    case exchange_rate_id
    when top_ids[0]
      return '1'
    when top_ids[1]
      return '2'
    when top_ids[2]
      return '3'
    else
      return ''
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
#
