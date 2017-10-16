require 'ostruct'

module Servicenow

  class Change < OpenStruct

    @_client = nil
    
    # @param [String] notes the notes to post
    #
    # @return [Servicenow::Change] the change
    def add_work_notes(notes)
      url = format('%s/change_request/%s', client.snow_table_url, sys_id)

      query = {
        work_notes: notes
      }

      response = client.send_request(url, query, :patch)
      change
    end


    # @param [Hash] extra options to override default query, or non-standard
    #                     parameters / columns to send to the Change table
    #
    # @return [Servicenow::Change] the change
    def start(extra={})
      url = format('%s/change_request/%s', client.snow_table_url, sys_id)

      query = {
        state: states['work in progress'],
        work_start: Time.now.utc
      }.merge(extra)

      response = client.send_request(url, query, :patch)
      change
    end


    # @param [Hash] extra options to override default query, or non-standard
    #                     parameters / columns to send to the Change table
    #
    # @return [Servicenow::Change] the change
    def end_change(extra={})
      url = format('%s/change_request/%s', client.snow_table_url, sys_id)

      query = {
        state: states['work complete'],
        work_end: Time.now.utc
      }.merge(extra)

      response = client.send_request(url, query, :patch)
      change
    end


    # This is a convenience method only.  It cannot be used to reload a Change
    # *in place* but only to return a new copy of the same Change from the
    # server
    #
    # @return [Servicenow::Change] a refreshed copy of this Change
    def reload
      client.get_change(number)
    end


    
    private


    def client
      if @_client.nil?
        @_client = Servicenow::Client.new
      end
      @_client
    end


    def states
      {
        'open' => 1,
        'work in progress' => 2,
        'work complete' => 11,
        'work incomplete' => 4,
        'waiting on user' => -5,
      }
    end


    def completion_codes
      {
        'success' => 11
      }
    end

  end


end