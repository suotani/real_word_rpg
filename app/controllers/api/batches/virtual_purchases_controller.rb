class Api::Batches::VirtualPurchasesController < Api::BatchesController
  def create
    VirtualCustomerBatchJob.perform_later
    render json: { ok: true, queued: true }, status: :accepted
  end
end
