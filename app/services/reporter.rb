class Reporter

  # TODO mail & slack

  attr_reader :error_obj, :message

  def self.error(error_obj, message)
    new(error_obj: error_obj, message: message).error
  end

  def initialize(error_obj: nil, message:)
    @error_obj = error_obj if error_obj
    @message = message
  end

  def error
    Rails.logger.error "#{message}\n#{error_obj.message}"
    Rails.logger.error error_obj.backtrace.join("\n")
  end

end
