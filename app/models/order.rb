class Order < ApplicationRecord
  belongs_to :user
  has_many :items, class_name: 'OrderItem', dependent: :destroy
  has_many :period_orders, dependent: :destroy
  has_one  :shipping_address, dependent: :destroy
  has_many :trade_infos, dependent: :nullify

  default_scope { order(created_at: :asc) }
  scope :subscribe_orders, -> { where(period: true) }

  def close!
    self.status = 'closse'
    self.save
  end

  def current_period_order_json
    period_orders.where(current: true).last.to_json(except: [:created_at, :updated_at], methods: [:shipping_name, :status_name, :paid_name, :paid_at_date])
  end

  def period_order_paid!
    self.paid = true
    self.status = 'subscribe'
    self.payment_status = 'subscribe'
    self.paid_at = Time.current
    self.save!
  end

  # 當期定期訂單
  def current_period_order
    period_orders.where(current: true).last
  end

  # 訂閱中?
  def subscribe?
    self.period? && self.status == 'subscribe'
  end

  def type
    period ? '定期配送' : '一般訂單'
  end

  # 定期訂單品項
  def item

  end

  def status_name
    Reference::OrderStatus.to_name(self.status)
  end

  def payment_name
    Reference::PaymentStatus.to_name(self.payment_status)
  end


  ###### 方便測試用 #######
  def tcancel
    self.paid = false
    self.status = 'subscribe_cancel'
    self.payment_status = 'subscribe_cancel'
    self.save
  end
end
