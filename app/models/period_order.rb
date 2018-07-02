class PeriodOrder < ApplicationRecord
  belongs_to :user
  belongs_to :order

  has_many :trade_infos
end
