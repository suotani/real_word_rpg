class Admin::ResourcesController < Admin::ApplicationController
  before_action :set_model, except: [:models]
  before_action :set_record, only: [:show, :edit, :update, :destroy]

  EXCLUDED_COLUMNS = %w[
    id created_at updated_at encrypted_password reset_password_token
    reset_password_sent_at remember_created_at
  ].freeze

  def models
    @admin_models = self.class.available_models
  end

  def index
    @records = @model.all.order(id: :desc)
    @records = @records.page(params[:page]).per(50) if @records.respond_to?(:page)
  end

  def show; end

  def new
    @record = @model.new
  end

  def create
    @record = @model.new(record_params)
    if @record.save
      redirect_to admin_resource_record_path(model_name: @model_name, id: @record.id), notice: '作成しました'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    attrs = record_params_for_update
    if @record.update(attrs)
      redirect_to admin_resource_record_path(model_name: @model_name, id: @record.id), notice: '更新しました'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @record.destroy
    redirect_to admin_resource_record_list_path(model_name: @model_name), notice: '削除しました'
  end

  def self.available_models
    Dir[Rails.root.join('app/models/*.rb')]
      .map { |f| File.basename(f, '.rb') }
      .select do |name|
        klass = name.classify.constantize rescue nil
        klass && klass < ApplicationRecord && !klass.abstract_class?
      end
      .sort
  end

  helper_method :editable_columns, :all_columns, :associated_name

  def editable_columns(model = @model)
    model.column_names.reject { |c| EXCLUDED_COLUMNS.include?(c) }
  end

  def all_columns(model = @model)
    model.column_names
  end

  def associated_name(record, col)
    return nil unless col.end_with?('_id')
    assoc_name = col.delete_suffix('_id')
    return nil unless record.respond_to?(assoc_name)
    assoc = record.public_send(assoc_name)
    assoc&.respond_to?(:name) ? assoc.name.presence : nil
  end

  private

  def set_model
    @model_name = params[:model_name]
    allowed = self.class.available_models
    raise ActionController::RoutingError, 'Not Found' unless allowed.include?(@model_name)
    @model = @model_name.classify.constantize
  rescue NameError
    raise ActionController::RoutingError, 'Not Found'
  end

  def set_record
    @record = @model.find(params[:id])
  end

  def record_params
    cols = editable_columns
    cols += %w[password password_confirmation] if @model == User
    params.require(:record).permit(*cols)
  end

  def record_params_for_update
    p = record_params
    if @model == User && p[:password].blank?
      p.delete(:password)
      p.delete(:password_confirmation)
    end
    p
  end
end
