class ApplicationController < ActionController::API
  before_action :clear_default_charset

  private

  def clear_default_charset
    ActionDispatch::Response::default_charset = nil
  end
end
