require 'httparty'
# Graph API helper methods
module GraphHelper
  GRAPH_HOST = 'https://graph.microsoft.com'.freeze

  def make_api_call(endpoint, token, params = nil)
    headers = {
      "Authorization" => "Bearer #{token}"
    }

    query = params || {}

    HTTParty.get "#{GRAPH_HOST}#{endpoint}",
                 headers: headers,
                 query: query
  end

  def get_calendar_events(token)
    get_events_url = '/v1.0/me/events'

    query = {
      '$select' => 'subject,organizer,start,end',
      '$orderby' => 'createdDateTime DESC'
    }

    response = make_api_call get_events_url, token, query

    raise response.parsed_response.to_s || "Request returned #{response.code}" unless response.code == 200

    response.parsed_response['value']
  end

  def make_post_api_call(endpoint, token, body = nil)
    headers = {
      "Authorization" => "Bearer #{token}",
      "Content-type" => "application/json",
    }

    body ||= {}

    HTTParty.post "#{GRAPH_HOST}#{endpoint}",
                 headers: headers,
                 body: body
  end

  def create_calendar_event(token)
    create_events_url = '/v1.0/me/events'

    response = make_post_api_call create_events_url, token, payload.to_json

    raise response.parsed_response.to_s || "Request returned #{response.code}" unless response.code == 200

    response.parsed_response['value']

  end

  private
    def payload
      {
        "subject" => "Meeting in Nagpur",
        "body" => {
          "contentType" => "HTML",
          "content" => "Does late morning work for you?"
        },
        "start" => {
            "dateTime" => Time.use_zone("Chennai") { (Time.current + 1.day).strftime("%FT%R") },
            "timeZone" => "India Standard Time"
        },
        "end" => {
            "dateTime" => Time.use_zone("Chennai"){ (Time.current + 1.day + 2.hours).strftime("%FT%R") },
            "timeZone" => "India Standard Time"
        },
        "location" =>{
            "displayName" =>"Nagpur"
        },
        "attendees" => [
          {
            "emailAddress" => {
              "address" =>"ashok.allu94@ashokallu.onmicrosoft.com",
              "name" => "Ashok Allu"
            },
            "type" => "required"
          }
        ]
      }
    end
end