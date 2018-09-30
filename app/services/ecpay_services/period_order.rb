module EcpayServices

  class PeriodOrder < EcpayServices::Ecpay

    attr_reader :order, :items

    PERIOD_ORDER_OPTIONS = [
      :MerchantID,
      :PaymentType,
      :TradeDesc,
      :ChoosePayment,
      :ReturnURL,
    ]

    def self.call(*args)
      new(*args).call
    end

    def initialize(order)
      @order = order
      @items  = order.items
    end

    def call
      data = {
        MerchantTradeNo: order.merchant_trade_no,
        TotalAmount: get_total_amount,
        ItemName: get_items_name,
        PeriodAmount: get_total_amount,
        PeriodType: order.period_type,
        Frequency: order.frequency,
        ExecTimes: order.exec_times,
        ReturnURL: "#{Settings.root}/ecpay/period_order_notify",  # 付款完成 通知回傳網址
        ClientBackURL: "#{Settings.root}/account/orders/#{order.order_no}", # Client 端返回特店的按鈕連結
        # OrderResultURL: "#{Settings.root}/account/orders/#{order.order_no}", # Client 端回傳付款結果網址
      }

      data.merge!(necessary_data)
      data.merge!(CheckMacValue: PeriodOrder.generate_check_mac_value(data))
    end

    private

    def necessary_data
      data = EcpayServices::EcpaySettings::OPTIONS.select {|key, value| key.in?(PERIOD_ORDER_OPTIONS)}
      data.merge(MerchantTradeDate: Time.current.to_s(:complete) )
    end

    # 綠界如有多個item，需以 # 分隔
    # 目前定期訂單 item 只有一個
    def get_items_name
      items.first.product_name
    end

    # 每期的錢
    # 定期訂單 TotalAmount 與 PeriodAmount 必須相同
    def get_total_amount
      order.period_amount + order.shipping_rate
    end

  end

end
