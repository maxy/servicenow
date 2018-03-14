require 'servicenow/version'
require 'servicenow/client'
require 'servicenow/change'

# This module is the base for the ServiceNow gem.  It's primary
# interface consists of the 'configure', 'configuration'
# and 'logger' methods
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
    @configuration = OpenStruct.new({}) if @configuration.nil?
    yield @configuration
  end


  # @return [Servicenow::Configuration]
  def self.configuration
    @configuration = OpenStruct.new({}) if @configuration.nil?
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
    @logger = Logger.new(STDOUT) if @logger.nil?
    @logger
  end

end
