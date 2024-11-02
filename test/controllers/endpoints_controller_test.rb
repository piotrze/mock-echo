require "test_helper"

class EndpointsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @endpoint = endpoints(:one)
  end

  test "should get index" do
    endpoint2 = endpoints(:two)

    get endpoints_url, as: :json, headers: { "Accept": "application/vnd.api+json" }

    assert_response :success
    assert_equal(
      "application/vnd.api+json",
      response.headers['Content-Type']
    )
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
          path: "/test3",
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
      post endpoints_url, params: params, as: :json, headers: { "Accept": "application/vnd.api+json", "Content-Type": "application/vnd.api+json" }

      assert_response :created
      assert_equal(
        {
          data: {
            id: "980190963",
            type: "endpoints",
            attributes: {
              verb: "GET",
              path: "/test3",
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
      post endpoints_url, params: params, as: :json, headers: { "Accept": "application/vnd.api+json", "Content-Type": "application/vnd.api+json" }

      assert_response :unprocessable_entity
      assert_equal(
        { errors: [{ code: "invalid_attributes", detail: "verb must be one of: GET, HEAD, POST, PUT, DELETE, CONNECT, OPTIONS, TRACE, PATCH" }] },
        json_response
      )
    end
  end

  test "should not create endpoint when wrong request format" do
    params = { path: "/test" }

    post endpoints_url, params: params, as: :json, headers: { "Accept": "application/vnd.api+json", "Content-Type": "application/vnd.api+json" }

    assert_response :bad_request
    assert_equal(
      { errors: [{ code: "invalid_request", detail: "param is missing or the value is empty: data" }] },
      json_response
    )
  end

  test "should not create endpoint when wrong attributes" do
    params = { data: { attributes: {} } }

    post endpoints_url, params: params, as: :json, headers: { "Accept": "application/vnd.api+json", "Content-Type": "application/vnd.api+json" }

    assert_response :unprocessable_entity
    assert_equal(
      { 
        errors: 
          [
            { code: "invalid_attributes", detail: "path is missing" },
            { code: "invalid_attributes", detail: "verb is missing" },
            { code: "invalid_attributes", detail: "response is missing" }
          ]
      },
      json_response
    )
  end

  test "should show endpoint" do
    get endpoint_url(@endpoint), as: :json, headers: { "Accept": "application/vnd.api+json" }
    assert_response :success
  end

  test "should update endpoint" do
    params = {
      data: {
        type: "endpoints",
        attributes: { 
          path: @endpoint.path, 
          verb: @endpoint.verb,
          response: { body: 'new response', code: 200, headers: { "Content-Type": "application/json" } },
        }
      }
    }

    patch endpoint_url(@endpoint), params: params, as: :json, headers: { "Accept": "application/vnd.api+json", "Content-Type": "application/vnd.api+json" }
    assert_response :success
    assert_equal(
      {
        data: {
          id: @endpoint.id.to_s,
          type: "endpoints",
          attributes: {
            verb: @endpoint.verb,
            path: @endpoint.path,
            response: { body: 'new response', code: 200, headers: { "Content-Type": "application/json" } },
          }
        }
      },
      json_response
    ) 
  end

  test "should destroy endpoint" do
    assert_difference("Endpoint.count", -1) do
      delete endpoint_url(@endpoint), as: :json, headers: { "Accept": "application/vnd.api+json" }
    end

    assert_response :no_content
  end
end
