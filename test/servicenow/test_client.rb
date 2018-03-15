require 'test_helper'

class ClientTest < Minitest::Test
  include Servicenow

  def setup
    Servicenow.configure do |config|
      config.username = nil
      config.password = nil
      config.base_url = nil
    end
  end

  def valid_client
    Client.new(
      username: 'foo',
      password: 'whatevs',
      url: 'thing'
    )
  end

  def test_that_it_requires_username
    assert_raises(MissingParameterError) {
      Client.new(
        password: 'foo',
        url: 'whatevs'
      )
    }
  end

  def test_that_it_requires_password
    assert_raises(MissingParameterError) {
      Client.new(
        username: 'foo',
        url: 'whatevs'
      )
    }
  end

  def test_that_it_requires_url
    assert_raises(MissingParameterError) {
      Client.new(
        username: 'foo',
        password: 'whatevs'
      )
    }
  end

  def test_valid_with_required_params
    Client.new(
      username: 'foo',
      password: 'whatevs',
      url: 'whatevs'
    )
  end

  def test_env_override_username
    ENV.stub :fetch, 'not_foo' do
      client = Client.new(
        username: 'foo',
        password: 'whatevs',
        url: 'thing'
      )
      assert client.instance_variable_get('@snow_api_username') == 'not_foo'
    end
  end

  def test_env_override_password
    ENV.stub :fetch, 'not_whatevs' do
      client = Client.new(
        username: 'foo',
        password: 'whatevs',
        url: 'thing'
      )
      assert client.instance_variable_get('@snow_api_password') == 'not_whatevs'
    end
  end

  def test_env_override_url
    ENV.stub :fetch, 'not_thing' do
      client = Client.new(
        username: 'foo',
        password: 'whatevs',
        url: 'thing'
      )
      assert client.instance_variable_get('@snow_api_base_url') == 'not_thing'
    end
  end

  def test_get_change
    client = valid_client

    mock_response = Minitest::Mock.new
    mock_response.expect :body, '{"result":[{"foo":"bar"}]}'

    client.stub :send_request, mock_response do
      change = client.get_change('123')

      assert change.foo == 'bar'

      mock_response.verify
    end
  end

  def test_get_changes_by_query
    client = valid_client
    mock_response = Minitest::Mock.new
    mock_response.expect :body, '{"result":[{"foo":"bar"}]}'
    mock_response.expect 'nil?', true

    client.stub :send_request, mock_response do
      changes = client.get_changes_by_query('someencodedquery')

      assert changes[0].foo == 'bar'

      mock_response.verify
    end
  end
  

end

