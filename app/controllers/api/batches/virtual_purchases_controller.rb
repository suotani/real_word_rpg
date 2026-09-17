class Api::Batches::VirtualPurchasesController < Api::BatchesController
  def create
    result = VirtualCustomerBatchService.new.run
    render json: { ok: true, queued: true, result: result }, status: :accepted
  end
end
