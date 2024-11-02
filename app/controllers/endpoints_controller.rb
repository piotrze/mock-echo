class EndpointsController < ApplicationController
  include JSONAPI::Deserialization
  
  rescue_from ActiveRecord::RecordNotFound do |e|
    render json: ErrorSerializer.serialize_errors('not_found' => 'Record not found'), 
           status: :not_found
  end
  
  rescue_from ActionController::ParameterMissing do |e|
    render json: ErrorSerializer.serialize_errors('invalid_request' => e.message), 
           status: :bad_request
  end

  before_action :set_endpoint, only: %i[ show update destroy ]

  def index
    endpoints = repository.all
    render jsonapi: endpoints, each_serializer: Endpoints::Serializer
  end

  def show
    render json: Endpoints::Serializer.new(@endpoint).serializable_hash
  end

  def create
    contract = Endpoints::Contract.new.call(endpoint_params)
    if contract.success?
      endpoint = Endpoints::Repository.create(**contract.to_h)

      render json: Endpoints::Serializer.new(endpoint).serializable_hash, 
             status: :created
    else
      render json: ErrorSerializer.serialize_errors_from_contract('invalid_attributes', contract.errors), 
             status: :unprocessable_entity
    end
  end

  def update
    contract = Endpoints::Contract.new.call(endpoint_params)
    if contract.success?
      @endpoint = repository.update(@endpoint, **contract.to_h)

      render json: Endpoints::Serializer.new(@endpoint).serializable_hash
    else
      render json: ErrorSerializer.serialize_errors_from_contract('invalid_attributes', contract.errors), 
             status: :unprocessable_entity
    end
  end

  def destroy
    @endpoint.destroy!
  end

  private

  def repository
    Endpoints::Repository
  end

  def set_endpoint
    @endpoint = repository.find(params[:id])
  end

  def endpoint_params
    jsonapi_deserialize(params, only: [:verb, :path, :response])
  end

  def jsonapi_serializer_class(resource, is_collection)
    Endpoints::Serializer
  end
end
