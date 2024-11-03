class MocksController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound do |e|
    render json: ErrorSerializer.serialize_errors({
      not_found: "Requested resource does not exist"
    }), status: :not_found
  end

  def show
    if endpoint
      render_endpoint_response
    else
      render json: not_found_response, status: :not_found
    end
  end
  
  private

  def endpoint
    @endpoint ||= repository.find_by_path_and_verb(request.path, request.method)
  end

  def content_type
    endpoint.response_headers&.[]('Content-Type') || 'application/json'
  end

  def repository
    Endpoints::Repository
  end

  def not_found_response
    ErrorSerializer.serialize_errors(not_found: "Requested page #{request.path} does not exist")
  end

  def clear_default_charset
    ActionDispatch::Response::default_charset = nil
  end

  def render_endpoint_response
    delay
    override_response_code

    render plain: endpoint.response_body, 
           status: endpoint.response_code, 
           content_type: content_type,
           headers: endpoint.response_headers
  end

  def delay
    if ENV.fetch('MOCK_DELAY', nil).present?
      sleep(ENV.fetch('MOCK_DELAY').to_f)
    end
  end

  def override_response_code
    if ENV.fetch('MOCK_OVERRIDE_RESPONSE_CODE', nil).present?
      endpoint.response_code = ENV.fetch('MOCK_OVERRIDE_RESPONSE_CODE').to_i
    end
  end
end
