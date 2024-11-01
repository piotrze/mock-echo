class MocksController < ApplicationController
  def show
    clear_default_charset

    if endpoint
      render plain: endpoint.response_body, 
             status: endpoint.response_code, 
             content_type: content_type,
             headers: endpoint.response_headers
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
end
