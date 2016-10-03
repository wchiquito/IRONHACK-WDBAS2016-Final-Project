require_relative './emt_response'
require_relative './emt_api'

class EMTCommand
  WHITE_SPACE = 32.chr
  VALID_COMMANDS = %w(
    wt
    help
  )

  def execute user_text
    command, parameters = get_command_and_parameters user_text
    begin
      valid_command?(command) ? self.send(command, *parameters)
                              : unknown_command
    rescue Exception => e
      bad_execution e
    end
  end

  private

  def get_command_and_parameters user_text
    return unknown_command if user_text.nil? || user_text.empty?
    prepare_command user_text
    command_and_params = user_text.split /\s/
    [command_and_params.shift.downcase, command_and_params]
  end

  def valid_command? command
    self.class::VALID_COMMANDS.include?(command) &&
    self.private_methods.include?(command.to_sym)
  end

  def help
    get_message __method__
  end

  def wt stop, line
    emt_api = EMTApi.new
    emt_api.get_arrive_stop stop, line
  end

  def unknown_command
    get_message __method__
  end

  def bad_execution message
    (response = get_message __method__)[:message] << " [#{message}]"
    response
  end

  def prepare_command text
    text.gsub! /\s+/, WHITE_SPACE
    text.strip!
    text.upcase!
  end

  def get_message method
    EMTResponse.send method
  end
end