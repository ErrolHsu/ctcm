module MailServices
  class Mailer
    API_KEY = Settings.mailgun.api_key
    DOMAIN = Settings.mailgun.domain
    FROM = 'Altitude Tosteria <services@altitudetosteria.com>'

    def self.send(from: FROM, to:, subject:, text:)
      mg_client = Mailgun::Client.new(API_KEY)
      message_params = { from: from,to: to, subject: subject, text: text }
      mg_client.send_message(DOMAIN, message_params)
    end

    def self.test

      subject = 'sidekiq'
      text = ERB.new(<<~heredoc).result(binding)
        這是
          一個
        sidekiq 測試

      heredoc

      send(to: "s20a3264@gmail.com", subject: subject, text: text)
    end

  end
end
