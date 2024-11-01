require 'test_helper'

class Endpoints::ContractTest < ActiveSupport::TestCase
  def setup
    @contract = Endpoints::Contract.new
  end

  def test_valid_parameters
    params = {
      path: '/api/v1/users',
      verb: 'GET',
      response: {
        code: 200,
        headers: { 'Content-Type' => 'application/json' },
        body: '{"status": "success"}'
      }
    }
    
    result = @contract.call(params)
    assert result.success?
  end

  def test_missing_path
    result = @contract.call(
      verb: 'GET',
      response: { code: 200 }
    )
    
    assert_includes result.errors[:path], 'is missing'
  end

  def test_missing_verb
    result = @contract.call(
      path: '/api/users',
      response: { code: 200 }
    )
    
    assert_includes result.errors[:verb], 'is missing'
  end

  def test_invalid_verb
    result = @contract.call(
      path: '/api/users',
      verb: 'INVALID',
      response: { code: 200 }
    )
    
    assert_includes result.errors[:verb], 'must be one of: GET, HEAD, POST, PUT, DELETE, CONNECT, OPTIONS, TRACE, PATCH'
  end

  def test_missing_response_code
    result = @contract.call(
      path: '/api/users',
      verb: 'GET',
      response: {}
    )
    
    assert_includes result.errors[:response][:code], 'is missing'
  end

  def test_invalid_response_code_type
    result = @contract.call(
      path: '/api/users',
      verb: 'GET',
      response: { code: 'not_an_integer' }
    )
    
    assert_includes result.errors[:response][:code], 'must be an integer'
  end

  def test_optional_response_headers
    params = {
      path: '/api/users',
      verb: 'GET',
      response: { code: 200 }
    }
    
    result = @contract.call(params)
    assert result.success?
  end

  def test_optional_response_body
    params = {
      path: '/api/users',
      verb: 'GET',
      response: { code: 200 }
    }
    
    result = @contract.call(params)
    assert result.success?
  end
end 