require 'test_helper'
require 'logger'

class ServicenowTest < Minitest::Test

  def test_that_it_has_a_version_number
    refute_nil ::Servicenow::VERSION
  end

  def test_default_logger
    assert Servicenow.logger.is_a? Logger
  end

  def test_assigned_logger
    foo_logger = Logger.new('/dev/null')
    old_logger = Servicenow.logger
    Servicenow.logger = foo_logger
    assert Servicenow.logger != old_logger
  end
  
end
