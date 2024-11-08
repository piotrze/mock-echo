require "test_helper"

class MocksControllerTest < ActionDispatch::IntegrationTest
  test 'should respond to GET' do
    get '/test'

    assert_response :success
    assert_equal 'application/json', response.headers['Content-Type']
    assert_equal '{ "message": "test" }', response.body
  end

  test 'should respond to POST' do
    post '/test2'

    assert_response :success
    assert_equal 'text/plain', response.headers['Content-Type']
    assert_equal 'test2', response.body
  end

  test 'should not respond to known path with unknown method' do
    get '/test2'

    assert_response :not_found
    assert_equal(
      { errors: [{ code: "not_found", detail: "Requested page /test2 does not exist" }] },
      json_response
    )
  end

  test 'should respond with 404 for unknown path' do
    get '/unknown'

    assert_response :not_found
    assert_equal(
      {
        errors: [
          { code: "not_found", detail: "Requested page /unknown does not exist" }
        ]
      },
      json_response
    )
  end

  test 'should not respond to shorter path' do
    Endpoint.create!(path: '/foo/bar/baz', verb: 'POST', response_body: 'test', response_code: 200)

    get '/foo/bar/baz'
    assert_response :not_found

    get '/foo/bar'
    assert_response :not_found

    post '/foo/bar'
    assert_response :not_found
  end

  test 'should respond with delay' do
    ENV['MOCK_DELAY'] = '0.1'

    get '/test'

    assert_response :success
  end

  test 'should respond with overridden response code' do
    ENV['MOCK_OVERRIDE_RESPONSE_CODE'] = '400'

    get '/test'

    assert_response :bad_request
  end
end
