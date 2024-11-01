class ErrorSerializer
  ErrorData = Data.define(:code, :detail)
  
  def self.serialize_errors(errors)
    errors = errors.to_h
    errors_array = case errors
    when ActiveModel::Errors
      errors.map { |field, message| ErrorData.new(code: field.to_s, detail: message) }
    when Hash
      errors.map { |field, message| ErrorData.new(code: field.to_s, detail: message) }
    else
      [ErrorData.new(code: 'unknown_error', detail: errors.to_s)]
    end
    
    { errors: errors_array.map(&:to_h) }
  end
end 