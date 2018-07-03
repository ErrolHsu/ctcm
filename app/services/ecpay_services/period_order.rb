module EcpayServices

  class PeriodOrder < EcpayServices::Ecpay

    PERIOD_ORDER_OPTIONS = [
      :MerchantID,
      :PaymentType,
      :TradeDesc,
      :ChoosePayment,
      :ReturnURL,
      :OrderResultURL,
    ]

    def initialize(order)
      @order = order
      @item  = order.items.first
    end

    def call
      data = {
        MerchantTradeNo: @order.merchant_trade_no,
        TotalAmount: @order.period_amount,
        ItemName: @item.product_name,
        PeriodAmount: @order.period_amount,
        PeriodType: @order.period_type,
        Frequency: @order.frequency,
        ExecTimes: @order.exec_times,
        # OrderResultURL: "http://localhost:3000/orders/ecpay_return",
      }

      data.merge!(necessary_data)
      data.merge!(CheckMacValue: PeriodOrder.generate_check_mac_value(data))
    end

    private

    def necessary_data
      data = EcpayServices::EcpaySettings::OPTIONS.select {|key, value| key.in?(PERIOD_ORDER_OPTIONS)}
      data.merge(MerchantTradeDate: Time.current.to_s(:complete) )
    end

  end

end
