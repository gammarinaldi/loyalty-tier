module AuthHelpers
  def headers
    { "Authorization" => "Bearer #{ ENV.fetch("AUTH_TOKEN") }" }
  end
end
