module EcpayServices
  module EcpaySettings
    OPTIONS = {
      MerchantID: Settings.ecpay.merchant_id, # 特店編號
      PaymentType: 'aio',                      # 交易類型，固定帶 aio
      TradeDesc: '訂單測試',                    # 交易描述，需先UrlEncode
      ChoosePayment: 'Credit',                 # 選擇預設付款方式
      ReturnURL: 'https://google.com',                           # 付款完成 通知回傳網址
      OrderResultURL: '',                      # Client 端回傳付款結果網址
      ClientBackURL: '',                       # Client 端返回特店的按鈕連結
      ClientRedirectURL: '',                   # Client 端回傳付款相關資訊
    }
  end
end
