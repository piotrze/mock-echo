class Endpoints::Contract < Dry::Validation::Contract
  params do
    required(:path).filled(:string)
    required(:verb).filled(:string)
    required(:response).hash do
      required(:code).filled(:integer)
      optional(:headers).filled(:hash)
      optional(:body).filled(:string)
    end
  end
end
