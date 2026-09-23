class Store::EmployeesController < Store::ApplicationController
  before_action :set_store

  def show
    @employee_types = EmployeeType.order(:hire_cost)
  end

  def create
    employee_type = EmployeeType.find(params[:employee_type_id])
    @store.hire_employee!(current_user, employee_type)
    redirect_to store_store_employee_path(@store), notice: "「#{employee_type.name}」を雇いました。"
  rescue ArgumentError => e
    redirect_to store_store_employee_path(@store), alert: e.message
  end

  def destroy
    @store.dismiss_employee!
    redirect_to store_store_employee_path(@store), notice: '従業員を解雇しました。'
  end

  private

  def set_store
    @store = current_user.stores.find(params[:store_id])
  end
end
