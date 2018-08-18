module MailServices
  class TrialMailer < MailServices::Mailer

    def self.reject(trial)
      subject = 'SORRY'
      text = <<-heredoc
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
      subject = '已寄出'
      text = "#{trial.name} 你的#{trial.product_name}已寄出"
      send(to: trial.email, subject: subject, text: text)
    end

  end
end
