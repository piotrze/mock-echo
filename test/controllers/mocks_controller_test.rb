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
end
