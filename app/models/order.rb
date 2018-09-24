class Order < ApplicationRecord
  belongs_to :user
  has_many :items, class_name: 'OrderItem', dependent: :destroy
  has_many :period_orders, dependent: :destroy
  has_one  :shipping_address, dependent: :destroy
  has_many :trade_infos, dependent: :nullify

  def period_order_paid!
    self.status = 'process'
    self.payment_status = 'subscribe'
    self.paid_at = Time.current
    self.save!
  end
end
