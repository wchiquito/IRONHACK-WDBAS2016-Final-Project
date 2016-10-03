class SlackResponse
  def self.invalid_token options
    defaults = {
      message: 'Sorry, not valid token',
      color: 'danger'
    }.merge! options
    self.from_emt defaults
  end

  def self.from_emt options
    defaults = {
      response_type: 'ephemeral',
      ts: Time.now.to_i,
      mrkdwn: [],
      pretext: '',
      footer: ''
    }.merge! options
    {
      body: {
        'response_type' => defaults[:response_type],
        'attachments' => [
          {
            'fallback' => defaults[:fallback] || defaults[:message],
            'color' => defaults[:color],
            'pretext' => defaults[:pretext],
            'text' => defaults[:message],
            'ts' => defaults[:ts],
            'footer' => defaults[:footer],
            'mrkdwn_in' => defaults[:mrkdwn]
          }
        ]
      }.to_json,
      headers: {
        'content-type' => 'application/json'
      }
    }
  end
end
