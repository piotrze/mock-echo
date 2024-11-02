class Endpoints::Repository
  class << self
    def create(verb:, path:, response:)
      Endpoint.create(
        verb: verb,
        path: path,
        response_body: response[:body],
        response_code: response[:code],
        response_headers: response[:headers]
      )
    end

    def update(endpoint, verb:, path:, response:)
      endpoint.update(
        verb: verb,
        path: path,
        response_body: response[:body],
        response_code: response[:code],
        response_headers: response[:headers]
      ) && endpoint
    end

    def find(id)
      Endpoint.find(id)
    end

    def find_by_path_and_verb(path, verb)
      Endpoint.find_by(path: path, verb: verb)
    end

    def all
      Endpoint.all.order(:id)
    end
  end
end