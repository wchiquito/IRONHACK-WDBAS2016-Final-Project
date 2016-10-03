require_relative '../lib/slack/slack_client'
require_relative '../lib/emt/emt_client'

RSpec.describe 'SlackClient' do
  token, url = '123', 'https://nothing'

  let (:sc) { SlackClient.new token, url }

  it 'if token is nil should be false' do
    expect((SlackClient.new nil, url).isValidToken?).to be_falsey
  end

  it 'if token is empty should be false' do
    expect((SlackClient.new '', url).isValidToken?).to be_falsey
  end

  it 'if token is correct should be true' do
    expect(sc.isValidToken?).to be_truthy
  end

  it 'if message is invalid_token should be message for invalid_token' do
    expect((sc.format_message 'invalid_token', { ts: 1475077448 }).to_s).to eq '{:body=>"{\"response_type\":\"ephemeral\",\"attachments\":[{\"fallback\":\"Sorry, not valid token\",\"color\":\"danger\",\"pretext\":\"\",\"text\":\"Sorry, not valid token\",\"ts\":1475077448,\"footer\":\"\",\"mrkdwn_in\":[]}]}", :headers=>{"content-type"=>"application/json"}}'
  end
end

RSpec.describe 'EMTCommand' do
  let (:emtc) { EMTCommand.new }

  it 'if execute an invalid command should return error message' do
    expect((emtc.execute 'notexist').to_s).to eq '{:message=>"Sorry, we didn\'t quite catch that command. Try */emt help* for a list.", :color=>"danger"}'
  end

  it 'if execute an valid command with error in parameters should return error message' do
    expect((emtc.execute 'help 1').to_s).to eq '{:message=>"Sorry, problem trying to run the command, please check the parameters [wrong number of arguments (given 1, expected 0)]", :color=>"danger"}'
  end

  it 'prepare_command should return argument parsed' do
    expect(emtc.send :prepare_command, 'wt    70      1').to eq 'WT 70 1'
  end

  it 'prepare_command should return argument parsed' do
    expect(emtc.send :prepare_command, '   help     ').to eq 'HELP'
  end

  it 'valid_command? should return true if valid command' do
    expect(emtc.send :valid_command?, 'help').to be_truthy
  end

  it 'valid_command? should return false if invalid command' do
    expect(emtc.send :valid_command?, 'helpp').to be_falsey
  end

  it 'valid_command? should return false if nil command' do
    expect(emtc.send :valid_command?, nil).to be_falsey
  end
end