require 'erb'
module MailServices
  class OrderMailer < MailServices::Mailer

    def self.period_order_create(order)
      shipping_address = order.shipping_address

      subject = '[Altitude Tosteria][AT Cafe] 訂單確認'
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

      subject = '[Altitude Tosteria][AT Cafe] 付款完成'
      text = ERB.new(<<~heredoc).result(binding)
        <%= order.shipping_address.name %> 您好，

        我們已收到您的款項，
        訂單編號: <%= order.order_no %>
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

    def self.period_order_cancel(order)
      shipping_address = order.shipping_address

      subject = '[Altitude Tosteria][AT Cafe] 訂單已取消'
      text = ERB.new(<<~heredoc).result(binding)
        <%= order.shipping_address.name %> 您好，

        我們已取消您的訂單，
        訂單編號: <%= order.order_no %>
        希望您還喜歡我們的咖啡。

        我們期望能成為方便、符合人性的商家，
        如果您有什麼寶貴的意見，
        我們很樂意聽您分享。

        欲聯絡我們，
        請寫信至 hola@altitudetosteria.com
        或加入我們的line帳號: @aus8184o，
        我們期待再次為您服務！

        預祝您有個美好的一天，
        萬分感謝！

        Altitude Tosteria創辦人
        Afdel 阿福
      heredoc

      send(to: shipping_address.email, subject: subject, text: text)
    end

    def self.period_order_preparing(order)
      shipping_address = order.shipping_address

      subject = '[Altitude Tosteria][AT Cafe]您這一期的咖啡豆在烘焙囉'
      text = ERB.new(<<~heredoc).result(binding)
        <%= order.shipping_address.name %> 您好，

        您的訂單這一期的咖啡豆已經在排隊下鍋囉！
        訂單編號: <%= order.order_no %>
        預計三個工作天內完成烘焙。

        每一次的烘焙皆是創辦人親自手選出漂亮的生豆，
        烘焙後再次人工手選，挑出瑕疵豆，
        請您耐心等候！

        喜歡我們的產品嗎？別忘了和您的好友分享喔！

        預祝您有個美好的一天，
        萬分感謝！

        Altitude Tosteria創辦人
        Afdel 阿福
      heredoc

      send(to: shipping_address.email, subject: subject, text: text)
    end

    def self.period_order_shipping(order)
      current_period_order = order.current_period_order
      shipping_address = order.shipping_address

      subject = '[Altitude Tosteria][AT Cafe]本期出貨通知'

      text = ERB.new(<<~heredoc).result(binding)
        <%= order.shipping_address.name %> 您好，

        您的訂單[訂單編號]這一期的咖啡豆已經在路上囉！
        預計於三個工作天內送達。
        （偏遠地區、離島需三到五個工作天。）
        訂單編號: <%= order.order_no %>

        物流追蹤碼: <%= current_period_order.tracking_no %>
        您可以透過此追蹤碼，
        至http://postserv.post.gov.tw/pstmail/main_mail.html查詢。

        您喜歡用什麼方式沖煮咖啡呢？
        我們很樂於用創新的方式享用咖啡，
        也歡迎您和我們分享你的獨門咖啡。

        別忘了！
        一杯好的咖啡與好的朋友分享，
        會更加美味喔！

        預祝您有個美好的一天，
        萬分感謝！

        Altitude Tosteria創辦人
        Afdel 阿福
      heredoc

      send(to: shipping_address.email, subject: subject, text: text)
    end

  end
end
