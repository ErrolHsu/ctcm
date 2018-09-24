class PeriodOrder < ApplicationRecord
  belongs_to :user
  belongs_to :order

  has_many :trade_infos

  def paid!(params, order_id)
    self.status = 'pending'
    self.paid = true
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

end
