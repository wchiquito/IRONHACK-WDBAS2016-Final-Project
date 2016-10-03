require_relative '../../config/emt_settings'
require_relative './emt_request'
require_relative './emt_response'
require_relative '../services/http'

class EMTApi
  def get_arrive_stop stop, line
    response = send_request EMT_GEO[:GETARRIVESTOP],
                            EMTRequest.getArriveStop(stop)
    return EMTResponse.bad_execution unless has_response?(response)
    create_message_time_bus *process_response(response, line)
  end

  private

  def create_message_time_bus destination, time_bus_one, time_bus_two
    EMTResponse.time_bus destination, time_bus_one, time_bus_two
  end

  def process_response response, line
    times_of_line = get_times_of_line response, line
  end

  def get_times_of_line response, line
    filterLine = response['arrives'].select { |element| element['lineId'] == line }
    time_one, destination = filterLine[0].nil? ? [nil, nil]
                                               : [filterLine[0]['busTimeLeft'],
                                                  filterLine[0]['destination']
                                                 ]
    time_two = filterLine[1].nil? ? nil : filterLine[1]['busTimeLeft']
    [destination, time_one, time_two]
  end

  def has_response? response
    !(response.parsed_response.class == [].class)
  end

  def send_request uri, options
    HTTPService.base_uri EMT_SETTINGS[:API_URL_BASE]
    HTTPService.post uri, options
  end
end