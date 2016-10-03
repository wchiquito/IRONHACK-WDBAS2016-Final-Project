require_relative '../../config/emt_settings'

module BusType
  NOTYPE = 0
  PRINCIPAL = 1
  SECONDARY = 2
end

class EMTResponse
  def self.unknown_command
    {
      message: 'Sorry, we didn\'t quite catch that command. Try */emt help* for a list.',
      color: 'danger'
    }
  end

  def self.bad_execution
    {
      message: 'Sorry, problem trying to run the command, please check the parameters',
      color: 'danger'
    }
  end

  def self.time_bus destination, time_one, time_two
    text_one = get_text_by_time time_one, BusType::PRINCIPAL, destination
    text_two = get_text_by_time time_two, BusType::SECONDARY
    {
      pretext: text_one,
      fallback: text_one,
      message: text_two,
      color: 'good',
      footer: '<http://opendata.emtmadrid.es/ | Opendata Madrid>'
    }
  end

  def self.help
    help = <<-STRING
          Commands:
            - wt stop route (ex.: */emt wt 5715 151*)
            - help                     (ex.: */emt help*)
          STRING
    {
      message: help,
      color: 'good',
      mrkdwn: ['text']
    }
  end

  private

  def self.get_text_by_time time, type, destination = nil
    text, type = [EMT_TEXTS[:NO_BUS_INFORMATION], 0] if time.nil? || time.class != Fixnum
    if type > 0
      time_in_minutes = self.get_time_in_minutes time
      max_time = self.reaches_maximum_time? time_in_minutes
      if type == BusType::PRINCIPAL
        text = EMT_TEXTS[:PRINCIPAL_NEXT_STOP] % destination if time_in_minutes == 0
        text = EMT_TEXTS[:PRINCIPAL_TIME_ARRIVAL] % [destination, time_in_minutes] if time_in_minutes != 0
        text = EMT_TEXTS[:PRINCIPAL_TIME_MORE] % destination if max_time
      else
        text = EMT_TEXTS[:SECONDARY_NEXT_STOP] if time_in_minutes == 0
        text = EMT_TEXTS[:SECONDARY_TIME_NEXT] % time_in_minutes if time_in_minutes != 0
        text = EMT_TEXTS[:SECONDARY_TIME_MORE] if max_time
      end
    end
    text
  end

  def self.get_time_in_minutes time
    time / (EMT_SETTINGS[:API_TO_MINUTES]).to_i
  end

  def self.reaches_maximum_time? time
    time > (EMT_SETTINGS[:API_MAX_TIME]).to_i
  end
end