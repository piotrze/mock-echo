class Endpoints::Contract < Dry::Validation::Contract
  # HTTP methods as defined in RFC 7231 (HTTP/1.1)
  VERBS = %w[GET HEAD POST PUT DELETE CONNECT OPTIONS TRACE PATCH].freeze
  
  params do
    required(:path).filled(:string)
    required(:verb).filled(:string, included_in?: VERBS)
    required(:response).hash do
      required(:code).filled(:integer)
      optional(:headers).filled(:hash)
      optional(:body).filled(:string)
    end
  end
end
