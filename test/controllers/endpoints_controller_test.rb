require "test_helper"

class EndpointsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @endpoint = endpoints(:one)
  end

  test "should get index" do
    endpoint2 = endpoints(:two)

    get endpoints_url, as: :json

    assert_response :success
    assert_equal(
      {
        data: [ 
          {
            id: endpoint2.id.to_s,  
            type: "endpoints",
            attributes: {
              verb: "POST",
              path: "/test2",
              response: { 
                code: 200, 
                headers: { "Content-Type": "text/plain" }, 
                body: "test2" 
              }
            }
          },
          {
            id: @endpoint.id.to_s,
            type: "endpoints",
            attributes: {
              verb: "GET",
              path: "/test",
              response: { 
                code: 200, 
                headers: { "Content-Type": "application/json" }, 
                body: '{ "message": "test" }' 
              }
            }
          }
        ]
      },
      json_response
    )
  end

  test "should create endpoint" do
    params = {
      data: { 
        type: "endpoints",
        attributes: {
          path: "/test",
          verb: "GET",
          response: {
            body: '{ message: "test" }',
            code: 200,
            headers: {
              "Content-Type" => "application/json"
            }
          }
        }
      }
    }

    assert_difference("Endpoint.count") do
      post endpoints_url, params: params, as: :json

      assert_response :created
      assert_equal(
        {
          data: {
            id: "980190963",
            type: "endpoints",
            attributes: {
              verb: "GET",
              path: "/test",
              response: { 
                code: 200, 
                headers: { "Content-Type": "application/json" }, 
                body: '{ message: "test" }' 
              }
            }
          }
        },
        json_response
      )
    end
  end

  test "should not create endpoint with invalid verb" do
    params = {
      data: { type: "endpoints", attributes: { path: "/test", verb: "unknown", response: { body: "test", code: 200 } } }
    }

    assert_no_difference("Endpoint.count") do
      post endpoints_url, params: params, as: :json

      assert_response :unprocessable_entity
      assert_equal(
        { errors: [{ code: "invalid_verb", detail: "Verb must be one of: GET, HEAD, POST, PUT, DELETE, CONNECT, OPTIONS, TRACE, PATCH" }] },
        json_response
      )
    end
  end

  test "should show endpoint" do
    get endpoint_url(@endpoint), as: :json
    assert_response :success
  end

  test "should update endpoint" do
    patch endpoint_url(@endpoint), params: { endpoint: { path: @endpoint.path, response_body: @endpoint.response_body, response_code: @endpoint.response_code, response_headers: @endpoint.response_headers, verb: @endpoint.verb } }, as: :json
    assert_response :success
  end

  test "should destroy endpoint" do
    assert_difference("Endpoint.count", -1) do
      delete endpoint_url(@endpoint), as: :json
    end

    assert_response :no_content
  end
end
