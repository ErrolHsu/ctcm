# encoding: utf-8
class EcpayController < ApplicationController
  skip_before_action :verify_authenticity_token

  def order_notify
    ecpay_parameters = filter(params)
    ecpay_log('order_notify', "綠界回傳: #{ecpay_parameters.inspect}")
    mac = ecpay_parameters.delete('CheckMacValue')

    # CheckMacValue 錯誤
    unless EcpayServices::Ecpay.check(ecpay_parameters, mac)
      ecpay_log 'order_notify', "交易失敗 CheckMacValue 不相符!"
      render plain: '1|OK', status: 200
      return
    end

    # 綠界交易失敗
    unless ecpay_parameters['RtnCode'].to_s == '1'
      ecpay_log 'order_notify', "交易失敗 #{ecpay_parameters['RtnMsg']}"
      render plain: '1|OK', status: 200
      return
    end

    begin
      order = Order.find_by(merchant_trade_no: ecpay_parameters['MerchantTradeNo'])
      order.paid!(ecpay_parameters)
      ecpay_log 'order_notify', "交易成功: order_id: #{order.id}, order_no: #{order.order_no}"
      render plain: '1|OK', status: 200
    rescue => e
      ecpay_log 'order_notify', "發生錯誤 #{e.message}"
      render plain: '1|OK', status: 200
    end
  end

  private

  def filter(params)
    ecpay_parameters = params.permit(params.keys).to_h
    ecpay_parameters.delete('controller')
    ecpay_parameters.delete('action')
    ecpay_parameters
  end

end
