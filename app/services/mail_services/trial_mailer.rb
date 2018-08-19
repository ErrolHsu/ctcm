module MailServices
  class TrialMailer < MailServices::Mailer

    def self.reject(trial)
      subject = 'Altitude Tosteria即將開幕，免費商品大放送，錯過一次還有下次！'
      text = <<~heredoc
        您好：

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

      subject = 'Altitude Tosteria，試用包已寄出'
      text = <<~heredoc
        #{trial.name}您好

        #{product_name}已為您寄出。
      heredoc
      send(to: trial.email, subject: subject, text: text)
    end

  end
end
