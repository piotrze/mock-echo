class Endpoints::Contract < Dry::Validation::Contract
  # HTTP methods as defined in RFC 7231 (HTTP/1.1)
  VERBS = %w[GET HEAD POST PUT DELETE CONNECT OPTIONS TRACE PATCH].freeze

  option :record, optional: true
  
  params do
    required(:path).filled(:string)
    required(:verb).filled(:string, included_in?: VERBS)
    required(:response).hash do
      required(:code).filled(:integer)
      optional(:headers).filled(:hash)
      optional(:body).filled(:string)
    end
  end

  rule(:path, :verb) do
    scope = Endpoint.where(path: values[:path], verb: values[:verb])
    scope = scope.where.not(id: record&.id) if record
    key.failure('must be unique') if scope.exists?
  end
end
