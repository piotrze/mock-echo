class ErrorSerializer
  ErrorData = Data.define(:code, :detail)
  
  def self.serialize_errors(errors)
    errors = errors.to_h
    errors_array = case errors
    when ActiveModel::Errors, Hash
      errors.map { |field, message| ErrorData.new(code: field.to_s, detail: message) }
    else
      [ErrorData.new(code: 'unknown_error', detail: errors.to_s)]
    end

    format_errors(errors_array)
  end

  def self.serialize_errors_from_contract(code, errors)
    format_errors(
      errors
        .to_h
        .map { |field, message| ErrorData.new(code: code, detail: [field, message].join(' ')) }
    )
  end

  private

  def self.format_errors(errors)
    { errors: errors.map(&:to_h) }
  end
end 
