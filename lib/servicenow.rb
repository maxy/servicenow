require 'servicenow/version'
require 'servicenow/client'
require 'servicenow/change'

module Servicenow

  @logger = nil
  @configuration = nil
  
  class BaseError < StandardError; end
  class MissingParameterError < BaseError; end


  # Set up Servicenow config
  #
  # @example Set up with username.  Password and URL would come from environemnt
  #   Servicenow.configure do |config|
  #     config.username = 'foo'
  #   end
  #
  # @yieldparam config [Servicenow::Configuration]
  def self.configure(&block)
    if @configuration.nil?
      @configuration = OpenStruct.new({})
    end
    yield @configuration
  end


  # @return [Servicenow::Configuration]
  def self.configuration
    if @configuration.nil?
      @configuration = OpenStruct.new({})
    end
    @configuration
  end


  # @param [Logger] new_logger new logger for module
  #
  # @return [Logger]
  def self.logger=(new_logger)
    @logger = new_logger
  end


  # @todo filter password
  #
  # @return [Logger] the module logger
  def self.logger
    if @logger.nil?
      @logger = Logger.new(STDOUT)
    end
    @logger
  end

end
