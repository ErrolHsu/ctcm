class PeriodOrder < ApplicationRecord
  belongs_to :user
  belongs_to :order

  has_many :trade_infos

  default_scope { order(created_at: :asc) }

  def paid!(params, order_id)
    self.status = 'pending'
    self.paid = true
    self.paid_at = Time.current
    self.shipping_status = 'pending'
    self.save!
    self.trade_infos.create!({
      order_id: order_id,
      rtn_code: params['RtnCode'],
      merchant_trade_no: params['MerchantTradeNo'],
      trade_no: params['TradeNo'],
      trade_amt: params['TradeAmt'],
      amount: params['Amount'],
      rtn_msg: params['RtnMsg'],
      total_info: params,
    })

  end

  def status_name
    Reference::OrderStatus.to_name(self.status)
  end

  def shipping_name
    Reference::ShippingStatus.to_name(self.shipping_status)
  end

  def paid_at_date
    paid_at.try(:to_s, :date)
  end

  def paid_name
    paid ? '已付款' : '尚未付款'
  end

end
