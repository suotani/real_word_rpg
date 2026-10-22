class Api::Batches::FxTradesController < Api::BatchesController
  def create
    result = FxTradeBatchService.new.run
    render json: { ok: true, result: result }, status: :accepted
  end
end
