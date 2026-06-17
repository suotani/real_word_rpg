class Api::Batches::VirtualPurchasesController < Api::BatchesController
  def create
    result = VirtualCustomerBatchService.new.run
    render json: { ok: true, count: result[:count], total_amount: result[:total_amount], errors: result[:errors] }, status: :ok
  end
end
