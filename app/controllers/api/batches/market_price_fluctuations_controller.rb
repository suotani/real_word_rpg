class Api::Batches::MarketPriceFluctuationsController < Api::BatchesController
  def create
    result = MarketPriceFluctuationService.new.run
    render json: { ok: true, result: result }, status: :ok
  end
end
