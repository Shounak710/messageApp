class ApplicationController < ActionController::API
  include ActionController::Serialization
  before_action :authenticate_request
  # TODO: Why do you include an attr_reader here?
  attr_reader :current_user

  include ExceptionHandler

  private

  def authenticate_request
    @current_user = AuthorizeApiRequest.new(request.headers).call
    render json: { error: 'Not Authorized' }, status: 401 unless @current_user
  end
end
