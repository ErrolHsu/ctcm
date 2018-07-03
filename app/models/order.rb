class Order < ApplicationRecord
  belongs_to :user
  has_many :items, class_name: 'OrderItem', dependent: :destroy
  has_many :period_orders, dependent: :destroy
  has_one  :shipping_address, dependent: :destroy
  has_many :trade_infos, dependent: :nullify

  def paid!(params)
    self.status = 'pending'
    self.payment_status = 'subscribe'
    self.save!
    self.trade_infos.create!({
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
