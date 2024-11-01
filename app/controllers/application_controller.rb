class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound do |e|
    render json: ErrorSerializer.serialize_errors({
      not_found: "Requested resource does not exist"
    }), status: :not_found
  end
end
