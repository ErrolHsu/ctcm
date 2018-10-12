require 'erb'
module MailServices
  module Admin
    class OrderMailer < MailServices::Mailer

      class << self

        def period_order_cancel(order)
          admins = ::Admin.includes(:setting).select {|admin| admin.setting.order_cancel_mail }
          emails = admins.map(&:email)

          subject = '定期訂單取消通知'
          text = ERB.new(<<~heredoc).result(binding)
            訂單編號: <%= order.order_no %>
            綠界訂單編號: <%= order.merchant_trade_no %>

            此訂單已取消訂閱，請至綠界後台取消信用卡定期定額。
          heredoc

          emails.each do |email|
            send(to: email, subject: subject, text: text)
          end
        end

      end

      def self.period_order_create(order)
        # order_items = order.items
        # shipping_address = order.shipping_address

        # subject = '定期訂單已建立'
        # text = ERB.new(<<~heredoc).result(binding)
        #   這是
        #     一個
        #   測試
        #   <%= order_items.last.product_name %>
        # heredoc

        # send(to: shipping_address.email, subject: subject, text: text)
      end

      def self.period_order_paid(order)
        # shipping_address = order.shipping_address

        # subject = '定期訂單付款成功'
        # text = ERB.new(<<~heredoc).result(binding)
        #   這是
        #     一個
        #   測試
        #        付款成功
        # heredoc

        # send(to: shipping_address.email, subject: subject, text: text)
      end

    end
  end
end
