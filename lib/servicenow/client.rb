require 'base64'
require 'httpi'
require 'json'

module Servicenow

  class Client

    attr_reader :snow_api_base_url, :snow_table_url

    # Initialization parameters for username, password and URL are normally
    # set in the module configuration.  They can also be passed here, or
    # set in the environment.  The precedence is ENV > params > module config
    #
    # @param [Hash] params initialization parameters
    #
    # @option params [String] :username ServiceNow API username
    # @option params [String] :password ServiceNow API password
    # @option params [String] :base_url ServiceNow API URL
    #
    # @return [Servicenow::Client] new client
    def initialize(params={})
      @snow_api_username = ENV.fetch('SNOW_API_USERNAME', params.delete(:username))
      @snow_api_password = ENV.fetch('SNOW_API_PASSWORD', params.delete(:password))
      @snow_api_base_url = ENV.fetch('SNOW_API_BASE_URL', params.delete(:url))

      @snow_api_username ||= Servicenow.configuration.username
      @snow_api_password ||= Servicenow.configuration.password
      @snow_api_base_url ||= Servicenow.configuration.base_url

      raise MissingParameterError, 'ServiceNow API Username not set' if @snow_api_username.nil?
      raise MissingParameterError, 'ServiceNow API Password not set' if @snow_api_password.nil?
      raise MissingParameterError, 'ServiceNow API Base URL not set' if @snow_api_base_url.nil?

      @snow_table_url = format('%s/%s', @snow_api_base_url, 'table')
    end
    

    # @param [String] user_id uses LIKE query to match for substring in u_cr_requester field
    #
    # @return [Array<Servicenow::Change>]
    def get_changes_by_user(user_id)
      url = format('%s/change_request', @snow_table_url)
      query = {
          sysparm_limit: 10,
          sysparm_query: "active=true^GOTOu_cr_requester.u_name_idLIKE#{user_id}"
      }

      response = send_request(url, query)

      obj = JSON.parse response.body
      obj['result'].collect{ |c| Change.new(c) }
    end
    

    # @param [String] encodedquery a ServiceNow encoded query
    # @param [int] limit limit results, default 10
    # @param [int] page page of results, default 1
    #
    # @return [Array<Servicenow::Change>]
    def get_changes_by_query(encodedquery, limit=10, page=1)
      url = format('%s/change_request', @snow_table_url)
      query = {
          sysparm_limit: limit,
          sysparm_page: page,
          sysparm_query: encodedquery
      }

      response = send_request(url, query)
      Servicenow.logger.debug response
      
      obj = JSON.parse response.body
      obj['result'].collect{ |c| Change.new(c) }
    end


    # @param [String] number Change number
    #
    # @return [Servicenow::Change]
    def get_change(number)
      url = format('%s/change_request', @snow_table_url)
      query = {
          sysparm_limit: 1,
          number: number
      } 

      response = send_request(url, query)

      obj = JSON.parse response.body
      Change.new(obj['result'].first)
    end


    # @param [Hash] data the data to use for Change creation
    #
    # @return [Servicenow::Change]
    def create_change(data={})
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


    # protected


    def send_request(url, query, method=:get)
      request = HTTPI::Request.new(url)
      if %i[ patch put ].include? method
        request.body = query.to_json
      else
        request.query = query
      end
      request.auth.basic(@snow_api_username, @snow_api_password)
      request.headers['Accept'] = 'application/json'
      request.headers['Content-Type'] = 'application/json'
      request.proxy = ENV['http_proxy'] unless ENV.fetch('http_proxy', nil).nil?
      HTTPI.request(method, request)
    end

  end
end
