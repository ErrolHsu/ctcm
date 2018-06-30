module EcpayServices
  module Settings
    PaymentType = 'aio' # 交易類型，固定帶 aio
    TradeDesc = URI.encode('訂單測試') # 交易描述，需先UrlEncode
    ChoosePayment = 'Credit' # 選擇預設 付款方式

    ReturnURL= '' # 付款完成 通知回傳 網址
    OrderResultURL = '' # Client 端回 傳付款結 果網址
    ClientBackURL = '' # Client 端返 回特店的 按鈕連結
    ClientRedirectURL = '' # Client 端 回 傳付款相關 資訊
  end
end
