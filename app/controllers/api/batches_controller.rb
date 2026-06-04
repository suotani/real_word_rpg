class Api::BatchesController < ActionController::Base
  before_action :authenticate_batch_token!

  private

  def authenticate_batch_token!
    token = request.headers['X-Batch-Token']
    unless ActiveSupport::SecurityUtils.secure_compare(token.to_s, ENV.fetch('BATCH_SECRET_TOKEN', ''))
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end
end
