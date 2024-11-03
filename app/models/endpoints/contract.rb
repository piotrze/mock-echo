class Endpoints::Contract < Dry::Validation::Contract
  # HTTP methods as defined in RFC 7231 (HTTP/1.1)
  VERBS = %w[GET HEAD POST PUT DELETE CONNECT OPTIONS TRACE PATCH].freeze

  option :record, optional: true
  
  params do
    required(:path).filled(:string)
    required(:verb).filled(:string, included_in?: VERBS)
    required(:response).hash do
      required(:code).filled(:integer)
      optional(:headers).maybe(:hash)
      optional(:body).filled(:string)
    end
  end

  rule(:path) do
    # Validate path format: must start with / and contain valid URL characters
    # Ensure path starts with / and doesn't allow paths without leading /
    unless values[:path].match?(%r{\A/[a-zA-Z0-9\-._~!$&'()*+,;=:@%/]+\z})
      key.failure('must be a valid HTTP path starting with /')
    end
  end

  rule(:path, :verb) do
    scope = Endpoint.where(path: values[:path], verb: values[:verb])
    scope = scope.where.not(id: record&.id) if record
    key.failure('must be unique') if scope.exists?
  end
end
