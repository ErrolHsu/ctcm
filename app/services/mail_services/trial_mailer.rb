module MailServices
  class TrialMailer < MailServices::Mailer

    def self.reject(trial)
      subject = 'Altitude Tosteria即將開幕，免費商品大放送，錯過一次還有下次！'
      text = <<~heredoc
        #{trial.name} 小姐/先生 您好：

        感謝您參與Altitude Tosteria的開幕系列活動，
        我們的試喝包已經索取完畢。

        請持續關注我們，
        並推薦您的朋友認識Altitude Tosteria，
        我們不定期會有優惠活動，
        也即將在九月份隆重開幕，
        敬請期待！

        http://www.instagram.com/altitudetosteriacafe/

        All the best,
        Afdel Bernal
        CEO / Co-Founder, Altitude Tosteria
      heredoc

      send(to: trial.email, subject: subject, text: text)
    end

    def self.shipped(trial)
      product_name = trial.product_name
      product_name = '咖啡試用包' if product_name.blank?

      subject = 'Your AT coffee is coming your way!!'
      text = <<~heredoc
        Hi,

        您索取的試喝包已經寄出囉！
        想要煮好一杯好喝的咖啡，
        拿到新鮮的豆子還不夠。

        您可以到我們的Instagram頁面觀看沖煮方法，
        請搜尋@altitudetosteriacafe
        讓您在家也能做出一杯頂級的咖啡。

        希望我們提供的小短片能給您幫助，
        您也可以透過以下方式聯絡我們：
        e-mail: hola@altitudetosteria.com
        phone: 0900-761-526

        All the best,
        Afdel Bernal （阿福）
        CEO / Co-Founder, Altitude Tosteria
      heredoc
      send(to: trial.email, subject: subject, text: text)
    end

  end
end
