class Graph < ApplicationRecord
  belongs_to :exchange_report
  belongs_to :exchange_rate
end

# == Schema Information
#
# Table name: graphs
#
#  id                 :integer          not null, primary key
#  exchange_report_id :integer
#  exchange_rate_id   :integer
#
