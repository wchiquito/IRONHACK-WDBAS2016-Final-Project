require_relative '../../config/slack_settings'
require_relative './slack_response'
require_relative '../services/http'

class SlackClient
  def initialize token, response_url
    @token = token
    @response_url = response_url
  end

  def isValidToken?
    return true if !@token.nil? &&
                   !@token.empty? &&
                   @token == SLACK_SETTINGS[:WEBHOOK_TOKEN]
    false
  end

  def format_message type, options
    SlackResponse.public_send type.to_sym, options
  end

  def send_message message
    HTTPService.post @response_url, message
  end
end