# frozen_string_literal: true

Fabricator(:exchange_rate) do
  rate { 0.8 }
  date { Date.today.beginning_of_week }
  base_currency { "EUR" }
  target_currency { "USD" }
end
