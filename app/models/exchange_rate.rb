# frozen_string_literal: true

class ExchangeRate < ApplicationRecord
  validates :base_currency, :target_currency, :date, :rate, presence: true
  validates_presence_of :prediction, unless: :new_record?

  has_and_belongs_to_many :exchange_reports
  before_save :calculate_prediction

  # insert prediction algoritm here !NB! need to recalculate saved rates if changing algoritm
  def calculate_prediction
    return if prediction.present?
    change = rate * rand(-0.05..0.05).round(4).to_d # max change in rate is 10 percent
    self.prediction = rate + change
  end
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
#  prediction      :decimal(, )      not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  rates_multicolumn_index  (date,base_currency,target_currency)
#
