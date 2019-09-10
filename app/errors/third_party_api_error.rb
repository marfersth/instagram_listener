class ThirdPartyApiError < StandardError
  attr_reader :message, :code

  def initialize(message, code)
    @message = message
    @code = code
  end

  def show_error
    "message: #{@message[:message].body}, code: #{@code}"
  end
end
