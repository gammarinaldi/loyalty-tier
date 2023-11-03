class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods
  include Pagination

  TOKEN = ENV.fetch("AUTH_TOKEN")

  before_action :authenticate

  private

  def authenticate
    # header_value = request.authorization
    authenticate_or_request_with_http_token do |token, options|
      # Compare the tokens in a time-constant manner, to mitigate
      # timing attacks.
      ActiveSupport::SecurityUtils.secure_compare(token, TOKEN)
    end
  end
end
