# encoding: utf-8
class EcpayController < ApplicationController
  skip_before_action :verify_authenticity_token

  def period_order_notify
    ecpay_parameters = filter(params)
    ecpay_log('period_order_notify', "綠界回傳: #{ecpay_parameters.inspect}")
    mac = ecpay_parameters.delete('CheckMacValue')
    # CheckMacValue 錯誤
    unless EcpayServices::Ecpay.check(ecpay_parameters, mac)
      ecpay_log 'period_order_notify', "交易失敗 CheckMacValue 不相符!"
      render plain: '1|OK', status: 200
      return
    end

    # 綠界交易失敗
    unless ecpay_parameters['RtnCode'].to_s == '1'
      ecpay_log 'period_order_notify', "交易失敗 #{ecpay_parameters['RtnMsg']}"
      render plain: '1|OK', status: 200
      return
    end

    begin
      order = Order.find_by(merchant_trade_no: ecpay_parameters['MerchantTradeNo'])
      period_order = order.period_orders.last

      ActiveRecord::Base.transaction do
        order.period_order_paid!
        period_order.paid!(ecpay_parameters, order.id)
        # 建立下一筆 period_order
        order.period_orders.create!(
          user_id: order.user_id,
          no: period_order.no + 1,
          amount: order.period_amount,
          expected_date: get_expected_date(order),
          status: 'future',
          paid: false,
          shipping_status: '',
        )

        # MailServices::OrderMailer.period_order_paid(order)
        MailWorker::PeriodOrderPaidJob.perform_later(order.id)
        ecpay_log 'period_order_notify', "交易成功: order_id: #{order.id}, order_no: #{order.order_no}"
        render plain: '1|OK', status: 200
      end
    rescue => e
      Reporter.error(e, "period_order_notify錯誤 file: #{__FILE__}")
      ecpay_log 'period_order_notify', "發生錯誤 #{e.message}"
      render plain: '1|OK', status: 200
    end
  end

  def period_order_return
    # ecpay_parameters = filter(params)
    # mac = ecpay_parameters.delete('CheckMacValue')

    # # CheckMacValue 錯誤
    # unless EcpayServices::Ecpay.check(ecpay_parameters, mac)
    #   ecpay_log 'period_order_return', "CheckMacValue 不相符!"
    #   redirect_to root_path
    #   return
    # end

  end

  private

  def filter(params)
    ecpay_parameters = params.permit(params.keys).to_h
    ecpay_parameters.delete('controller')
    ecpay_parameters.delete('action')
    ecpay_parameters
  end

  def get_expected_date(order)
    if order.period_type == 'D'
      Date.current + order.frequency.days
    else
      Date.current + order.frequency.month
    end
  end

end
