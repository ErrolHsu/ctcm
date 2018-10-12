require 'erb'
module MailServices
  class OrderMailer < MailServices::Mailer

    def self.period_order_create(order)
      order_items = order.items
      shipping_address = order.shipping_address

      subject = '[Altitude Tosteria][AT Cafe]訂單確認'
      text = ERB.new(<<~heredoc).result(binding)
        <%= order.shipping_address.name %> 您好，

        我們已接收到了您的訂單。
        您的訂單號碼為： <%= order.order_no %>
        您可以在此確認您的訂單： <%= "https://altitudetosteria.com/account/orders/#{order.order_no}" %>
        若尚未完成付款，請至您的訂單儘速完成付款。

        為了提供您最新鮮的咖啡豆，
        每一次完成付款後才進行烘焙，
        長期配送會以定期定額的方式自動扣款，
        一次訂購，輕鬆配送。

        預祝您有個美好的一天，
        萬分感謝！

        Altitude Tosteria創辦人
        Afdel 阿福
      heredoc

      send(to: shipping_address.email, subject: subject, text: text)
    end

    def self.period_order_paid(order)
      shipping_address = order.shipping_address

      subject = '[Altitude Tosteria][AT Cafe]付款完成'
      text = ERB.new(<<~heredoc).result(binding)
        <%= order.shipping_address.name %> 您好，

        我們已收到您 <%= order.order_no %> 的款項，
        您可以在此查看您的訂單狀態：<%= "https://altitudetosteria.com/account/orders/#{order.order_no}" %>

        單品咖啡每一次的配送皆為新鮮烘焙，
        袋子的底部皆會標上烘焙日期，
        烘焙後的五到八天是風味到達最高點的時候，
        請把握最佳賞味期享用您的咖啡。

        請將咖啡豆置於乾燥、陰涼處存放，
        單品咖啡建議您於兩週內飲用完，
        義式咖啡與配方咖啡則有較長的賞味期，
        一個月內皆適合飲用。

        喜歡我們的產品嗎？別忘了和您的好友分享喔！

        預祝您有個美好的一天，
        萬分感謝！

        Altitude Tosteria創辦人
        Afdel 阿福
      heredoc

      send(to: shipping_address.email, subject: subject, text: text)
    end

  end
end
