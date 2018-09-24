require 'erb'
module MailServices
  class OrderMailer < MailServices::Mailer

    def self.period_order_create(order)
      order_items = order.items
      shipping_address = order.shipping_address

      subject = '定期訂單已建立'
      text = ERB.new(<<~heredoc).result(binding)
        這是
          一個
        測試
        <%= order_items.last.product_name %>
      heredoc

      send(to: shipping_address.email, subject: subject, text: text)
    end

    def self.period_order_paid(order)
      shipping_address = order.shipping_address

      subject = '定期訂單付款成功'
      text = ERB.new(<<~heredoc).result(binding)
        這是
          一個
        測試
             付款成功
      heredoc

      send(to: shipping_address.email, subject: subject, text: text)
    end

  end
end
