class Api::Batches::BaitoBatchesController < Api::BatchesController
  def create
    result = BaitoBatchService.new.run
    render json: { ok: true, result: result }, status: :ok
  end
end
