require 'base64'
require 'httpi'
require 'json'

module Servicenow

  class Client

    @@logger = nil
    attr_reader :snow_base_url

    def initialize(params={})
      @snow_api_username = ENV.fetch('SNOW_API_USERNAME')
      @snow_api_password = ENV.fetch('SNOW_API_PASSWORD')
      @snow_base_url = ENV.fetch('SNOW_API_BASE_URL')
      @snow_table_url = format('%s/%s', @snow_base_url, 'table')

      if params[:logger]
        @@logger = params.delete(:logger)
      else
        @@logger = Logger.new(STDOUT)
      end
    end


    def logger
      @@logger
    end


    def get_changes_by_user(user_id)
      url = format('%s/change_request', @snow_table_url)
      query = {
          sysparm_limit: 10,
          sysparm_query: 'active=true^GOTOu_cr_requester.u_name_idLIKE218947'
      }

      response = send_request(url, query)

      obj = JSON.parse response.body
      obj['result'].collect{ |c| Change.new(c) }
    end
    

    def get_changes_by_query(encodedquery, limit=10, page=1)
      url = format('%s/change_request', @snow_table_url)
      query = {
          sysparm_limit: limit,
          sysparm_page: page,
          sysparm_query: encodedquery
      }

      response = send_request(url, query)
      logger.debug response

      obj = JSON.parse response.body
      obj['result'].collect{ |c| Change.new(c) }
    end


    def get_change(number)
      url = format('%s/change_request', @snow_table_url)
      query = {
          sysparm_limit: 1,
          number: 'CHG0210847'
      } 

      response = send_request(url, query)

      obj = JSON.parse response.body
      Change.new(obj['result'].first)
    end


    def submit_change(data={})
      url = format('%s/change_request', @snow_table_url)
      query = {}
      query.merge(data)

      response = send_request(url, query, :post)
      new_change_url = response.headers['Location']

      obj = JSON.parse response.body
      change = Change.new(obj['result'].first)
      change.url ||= new_change_url
      change
    end


    private


    def send_request(url, query, method=:get)
      request = HTTPI::Request.new(url)
      request.query = query
      request.auth.basic(@snow_api_username, @snow_api_password)
      request.headers['Accept'] = 'application/json'
      request.headers['Content-Type'] = 'application/json'
      request.proxy = ENV['http_proxy'] unless ENV.fetch('http_proxy', nil).nil?
      HTTPI.request(method, request)
    end

  end
end
