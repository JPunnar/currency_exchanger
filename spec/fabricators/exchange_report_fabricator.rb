# frozen_string_literal: true

Fabricator(:exchange_report) do
  user
  amount { (rand(101) + 1) }
  max_wait_time_in_weeks { (rand(16) + 1) }
  base_currency { "EUR" }
  target_currency { "USD" }
end
