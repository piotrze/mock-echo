require "test_helper"

class EndpointsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @endpoint = endpoints(:one)
  end

  test "should get index" do
    get endpoints_url, as: :json
    assert_response :success
  end

  test "should create endpoint" do
    params = {
      path: "/test",
      verb: "get",
      response: {
        body: "test",
        code: 200,
        headers: {
          "Content-Type" => "application/json"
        }
      },
    }

    assert_difference("Endpoint.count") do
      post endpoints_url, params: { endpoint: params }, as: :json

      assert_response :created
      assert_equal(
        {
          data: {
            id: "980190963",
            type: "",
            attributes: {
              verb: "get",
              path: "/test",
              response: { code: 200, headers: nil, body: "test" }
            }
          }
        },
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
