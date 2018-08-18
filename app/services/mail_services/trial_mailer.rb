module MailServices
  class TrialMailer < MailServices::Mailer

    def self.reject(trial)
      subject = 'SORRY'
      text = "......."
      send(to: trial.email, subject: subject, text: text)
    end

    def self.shipped(trial)
      subject = '已寄出'
      text = "#{trial.name} 你的#{trial.product_name}已寄出"
      send(to: trial.email, subject: subject, text: text)
    end

  end
end
