require 'sinatra'
require_relative './lib/emt/emt_client'
require_relative './lib/slack/slack_client'

post '/postanonymize' do
  ProcessRequest.new params
end

class ProcessRequest
  def initialize params
    @slack_client = SlackClient.new params[:token],
                                    params[:response_url]
    @command = params[:text]
    run
  end

  private

  def run
    if @slack_client.isValidToken?
      emtc = EMTClient.new
      send_message_to_slack 'from_emt',
                            emtc.execute(@command)
    else
      send_message_to_slack 'invalid_token'
    end
  end

  def send_message_to_slack type, options = {}
    @slack_client.send_message @slack_client.format_message type,
                                                            options
  end
end