class Endpoints::Repository
  def self.create(verb:, path:, response:)
    Endpoint.create(
      verb: verb,
      path: path,
      response_body: response[:body],
      response_code: response[:code],
      response_headers: response[:headers]
    )
  end
end