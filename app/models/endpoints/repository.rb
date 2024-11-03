module Endpoints
  module Commands
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

    def destroy(endpoint)
      endpoint.destroy
    end
  end

  module Queries
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

  class Repository
    extend Commands
    extend Queries
  end
end