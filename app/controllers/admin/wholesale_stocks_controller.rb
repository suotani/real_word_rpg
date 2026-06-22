require 'csv'

class Admin::WholesaleStocksController < Admin::ApplicationController
  before_action :set_market
  before_action :set_stock, only: [:edit, :update, :destroy]

  CSV_HEADERS = %w[id 商品名 販売価格 並べ替えキー サブカテゴリ カテゴリ].freeze

  def index
    @stocks = @market.stocks.includes(item_sub_category: :item_category).order(:name)

    if params[:item_category_id].present?
      @stocks = @stocks.where(item_sub_categories: { item_category_id: params[:item_category_id] })
    end

    @item_categories = ItemCategory.order(:name)
  end

  def export
    stocks = @market.stocks.includes(item_sub_category: :item_category).order(:sort_key, :name)

    csv_data = CSV.generate(encoding: 'UTF-8') do |csv|
      csv << CSV_HEADERS
      stocks.each do |stock|
        csv << [
          stock.id,
          stock.name,
          stock.price,
          stock.sort_key,
          stock.item_sub_category&.name,
          stock.item_sub_category&.item_category&.name
        ]
      end
    end

    send_data "﻿#{csv_data}",
              filename: "wholesale_stocks_#{Date.today}.csv",
              type: 'text/csv; charset=UTF-8'
  end

  def import
    file = params[:csv_file]
    unless file
      redirect_to admin_wholesale_stocks_path, alert: 'CSVファイルを選択してください'
      return
    end

    errors  = []
    updated = 0

    ActiveRecord::Base.transaction do
      content = file.read.force_encoding('UTF-8').scrub
      content.delete_prefix!("\xEF\xBB\xBF")
      CSV.parse(content, headers: true) do |row|
        id    = row['id'].to_i
        stock = @market.stocks.find_by(id: id)

        unless stock
          errors << "ID #{id}: 見つかりません（スキップ）"
          next
        end

        unless stock.update(
          name:     row['商品名'].presence || stock.name,
          price:    row['販売価格'].to_i,
          sort_key: row['並べ替えキー']
        )
          errors << "ID #{id}: #{stock.errors.full_messages.join(', ')}"
        else
          updated += 1
        end
      end

      raise ActiveRecord::Rollback if errors.any?
    end

    if errors.any?
      redirect_to admin_wholesale_stocks_path, alert: "更新に失敗しました: #{errors.join(' / ')}"
    else
      redirect_to admin_wholesale_stocks_path, notice: "#{updated}件を更新しました"
    end
  rescue CSV::MalformedCSVError => e
    redirect_to admin_wholesale_stocks_path, alert: "CSVの形式が不正です: #{e.message}"
  end

  def new
    @item_categories = ItemCategory.order(:name)
  end

  def create
    item_category = ItemCategory.find_by(id: params[:item_category_id])
    name          = params.dig(:stock, :name).to_s.strip
    cost          = params.dig(:stock, :cost).to_i
    price         = params.dig(:stock, :price).to_i

    if item_category.nil? || name.blank?
      @item_categories = ItemCategory.order(:name)
      flash.now[:alert] = '商品カテゴリと商品名を入力してください'
      return render :new, status: :unprocessable_entity
    end

    ActiveRecord::Base.transaction do
      sub_cat = ItemSubCategory.find_or_initialize_by(name: name, item_category: item_category, town_id: nil)
      sub_cat.save! if sub_cat.new_record?

      stock = @market.stocks.find_by(item_sub_category: sub_cat)
      if stock
        stock.update!(cost: cost, price: price)
      else
        @market.stocks.create!(name: name, item_sub_category: sub_cat, user: nil, cost: cost, price: price)
      end
    end

    redirect_to admin_wholesale_stocks_path, notice: '商品を登録しました'
  rescue ActiveRecord::RecordInvalid => e
    @item_categories = ItemCategory.order(:name)
    flash.now[:alert] = e.record.errors.full_messages.join(', ')
    render :new, status: :unprocessable_entity
  end

  def edit; end

  def update
    if @stock.update(stock_params)
      redirect_to admin_wholesale_stocks_path, notice: '商品を更新しました'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @stock.destroy
    redirect_to admin_wholesale_stocks_path, notice: '商品を削除しました'
  end

  private

  def set_market
    @market = Store.central_wholesale_market
    redirect_to admin_root_path, alert: '中央卸売市場が存在しません' unless @market
  end

  def set_stock
    @stock = @market.stocks.find(params[:id])
  end

  def stock_params
    params.require(:stock).permit(:name, :price, :sort_key)
  end
end
