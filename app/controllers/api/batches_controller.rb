class Api::BatchesController < ActionController::Base
  protect_from_forgery with: :null_session
  before_action :authenticate_batch_token!

  private

  def authenticate_batch_token!
    secret = ENV['BATCH_SECRET_TOKEN'].presence
    unless secret
      render json: { error: 'BATCH_SECRET_TOKEN is not configured' }, status: :internal_server_error
      return
    end

    token = request.headers['X-Batch-Token']
    unless ActiveSupport::SecurityUtils.secure_compare(token.to_s, secret)
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end
end
