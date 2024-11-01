class EndpointsController < ApplicationController
  include JSONAPI::Deserialization
  include JSONAPI::Errors
  before_action :set_endpoint, only: %i[ show update destroy ]

  def index
    @endpoints = Endpoint.all.order(:id)
    render jsonapi: @endpoints, each_serializer: Endpoints::Serializer
  end

  def show
    render json: Endpoints::Serializer.new(@endpoint).serializable_hash
  end

  def create
    contract = Endpoints::Contract.new.call(endpoint_params)
    if contract.success?
      endpoint = Endpoints::Repository.create(**contract.to_h)
      render json: Endpoints::Serializer.new(endpoint).serializable_hash, 
             status: :created, 
             location: endpoint
    else
      render json: ErrorSerializer.serialize_errors(contract.errors), 
             status: :unprocessable_entity
    end
  end

  def update
    if @endpoint.update(endpoint_params)
      render json: Endpoints::Serializer.new(@endpoint).serializable_hash
    else
      render json: ErrorSerializer.serialize_errors(@endpoint.errors), 
             status: :unprocessable_entity
    end
  end

  def destroy
    @endpoint.destroy!
  end

  private

  def set_endpoint
    @endpoint = Endpoint.find(params[:id])
  end

  def endpoint_params
    jsonapi_deserialize(params, only: [:verb, :path, :response])
  end

  def jsonapi_serializer_class(resource, is_collection)
    Endpoints::Serializer
  end
end
