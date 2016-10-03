require_relative './emt_command'

class EMTClient
  def execute user_text
    emt_command = EMTCommand.new
    emt_command.execute user_text
  end
end