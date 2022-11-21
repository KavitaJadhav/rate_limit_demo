# frozen_string_literal: true
require "ipaddr"

Rack::Attack.cache.store = ActiveSupport::Cache::RedisStore.new(ENV["REDIS_URL"])

def notify(api, username)
  ActionMailer::Base.mail(
    from: "test@example.com",
    to: "admin@example.com",
    subject: "Exceed #{api} requests",
    body: "Exceed #{api} requests by user #{username}"
  ).deliver
end

# Rack::Attack.throttled_callback = lambda do |request|
#   notify('login', request.username) if request.login?
#   notify('contact_us', request.username) if request.contact_us?
#
#   # Response Body after API Limit reached
#   # Using 503 because it may make attacker think that they have successfully
#   # DOSed the site. Rack::Attack returns 429 for throttling by default
#   [503, { 'Content-Type' => 'application/json' }, [{ errors: { message: "Request limit exceeded. Please try later." } }.to_json]]
# end

Rack::Attack.throttled_responder = lambda do |request|
  notify('login', request.username) if request.login?
  notify('contact_us', request.username) if request.contact_us?

  # Response Body after API Limit reached
  # Using 503 because it may make attacker think that they have successfully
  # DOSed the site. Rack::Attack returns 429 for throttling by default
  [503, { 'Content-Type' => 'application/json' }, [{ errors: { message: "Request limit exceeded. Please try later." } }.to_json]]
end

class Rack::Attack
  class Request < ::Rack::Request

    def remote_ip
      @remote_ip ||= get_header('HTTP_X_FORWARDED_FOR').try(:to_s)
    end

    def username
      (params["username"] || "Anon").to_s.downcase
    end

    def login?
      self.path == "/sign_in" && self.post?
    end

    def contact_us?
      self.path == '/contact_us' && self.post?
    end
  end

  ## Login Block

  # IP per minute request
  throttle("ip:login-limit-per-minute", limit: APP_CONFIGS['rate_limits']['login_minute_ip'].to_i, period: 1.minute) do |req|
    if req.login?
      req.remote_ip
    end
  end

  # IP per day request
  throttle("ip:login-limit-daily", limit: APP_CONFIGS['rate_limits']['login_day_ip'].to_i, period: 1.day) do |req|
    if req.login?
      req.remote_ip
    end
  end

  # User per minute request
  throttle("username:login-limit-per-minute", limit: APP_CONFIGS['rate_limits']['login_minute_user'].to_i, period: 1.minute) do |req|
    if req.login?
      req.username
    end
  end

  # User per day request
  throttle("username:login-limit-daily", limit: APP_CONFIGS['rate_limits']['login_day_user'].to_i, period: 1.day) do |req|
    if req.login?
      req.username
    end
  end

  ## Contact Us Block
  # IP per minute request
  throttle("ip:contact-us-per-minute", limit: APP_CONFIGS['rate_limits']['login_minute_user'].to_i, period: 1.minute) do |req|
    if req.contact_us?
      req.remote_ip
    end
  end

  # IP per day request
  throttle("ip:contact-us-daily", limit: APP_CONFIGS['rate_limits']['login_minute_user'].to_i, period: 1.day) do |req|
    if req.contact_us?
      req.remote_ip
    end
  end

  # User per minute request
  throttle("username:contact-us-limit-per-minute", limit: APP_CONFIGS['rate_limits']['login_minute_user'].to_i, period: 1.minute) do |req|
    if req.contact_us?
      req.username
    end
  end

  # User per day request
  throttle("username:contact-us-limit-daily", limit: APP_CONFIGS['rate_limits']['login_minute_user'].to_i, period: 1.day) do |req|
    if req.contact_us?
      req.username
    end
  end
end
