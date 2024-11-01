class Endpoints::Serializer
  include JSONAPI::Serializer
  
  set_type :endpoints
  attributes :verb, :path
  attribute :response do |object|
    {
      code: object.response_code,
      headers: object.response_headers,
      body: object.response_body
    }
  end
end