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

  end
end
