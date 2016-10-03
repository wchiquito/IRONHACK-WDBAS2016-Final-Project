require_relative '../.././config/emt_settings'

class EMTRequest
  def self.getArriveStop stop, cultureInfo = 'ES'
    {
      body: {
        idClient: EMT_SETTINGS[:API_ID_CLIENT],
        passKey: EMT_SETTINGS[:API_PASS_KEY],
        idStop: stop,
        cultureInfo: cultureInfo
      }
    }
  end
end