require 'test_helper'

class ChangeTest < Minitest::Test
  include Servicenow


  def setup
    Servicenow.configure do |config|
      config.username = 'foo'
      config.password = 'foo'
      config.base_url = 'foo'
    end
    @change = Change.new
  end


  def test_that_first_call_client_returns_new_client
    assert_instance_of Servicenow::Client, @change.send(:client)
  end

  def test_that_subsequent_call_client_returns_same_client
    client = @change.send(:client)
    assert_equal client, @change.send(:client)
  end

end
