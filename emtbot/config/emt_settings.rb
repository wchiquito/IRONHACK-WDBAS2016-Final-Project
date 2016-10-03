EMT_SETTINGS = {
  API_URL_BASE: 'https://openbus.emtmadrid.es:9443/emt-proxy-server/last',
  API_ID_CLIENT: ENV['EMT_ID_CLIENT'],
  API_PASS_KEY: ENV['EMT_PASS_KEY'],
  API_TO_MINUTES: '60',
  API_MAX_TIME: '20'
}

EMT_GEO = {
  GETARRIVESTOP: '/geo/GetArriveStop.php'
}

EMT_TEXTS = {
  NO_BUS_INFORMATION: 'No bus information',
  PRINCIPAL_NEXT_STOP: 'Direction: %s. The bus is next to the bus stop',
  PRINCIPAL_TIME_MORE: 'Direction: %s. Estimated time of arrival more than 20 min. time',
  PRINCIPAL_TIME_ARRIVAL: 'Direction: %s. Estimated time of arrival %s min.',
  SECONDARY_TIME_NEXT: 'The next one will be arrive in %s min.',
  SECONDARY_NEXT_STOP: 'The next is next to the bus stop',
  SECONDARY_TIME_MORE: 'The next one will arrive in more than 20 min. time'
}