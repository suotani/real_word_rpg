class Htmladmin::ManagedHtmlsController < HtmladminController
  skip_before_action :authenticate_user!, only: [:show, :page]
  before_action :set_managed_html, only: [:show, :edit, :update, :destroy]
  before_action :check_public, :only => [:show]

  layout 'htmladmin/main'

  def index
    if params[:research].blank? && session[:search_filter].present?
      @filter = session[:search_filter].with_indifferent_access
    else
      @filter = { level: params[:level], tag: params[:tag], title: params[:title], sort: params[:sort], order: params[:order] }
    end
    session[:search_filter] = @filter
    order = @filter[:order] == "desc" ? :desc : :asc
    @managed_htmls = current_user.managed_htmls
    @managed_htmls = @managed_htmls.where(level: @filter[:level]) if @filter[:level].present?
    @managed_htmls = @managed_htmls.where("title LIKE '%#{@filter[:title]}%'")  if @filter[:title].present?
    @managed_htmls = @managed_htmls.order(level: order) if @filter[:sort] == "level"
    @managed_htmls = @managed_htmls.order(created_at: order) if @filter[:sort].nil? || @filter[:sort] == "created_at"
    @managed_htmls = @managed_htmls.order(updated_at: order) if @filter[:sort] == "updated_at"
    @managed_htmls = @managed_htmls.order(title: order) if @filter[:sort] == "title"
    @managed_htmls = @managed_htmls.page(params[:page])
  end

  def show
    render :layout => 'htmladmin/viewer'
  end

  def new
    @managed_html = ManagedHtml.new
    set_imports
  end

  def edit
    set_imports
  end

  def create
    @managed_html = current_user.managed_htmls.new(managed_html_params)
    if @managed_html.save
      delete_insert_imports
      redirect_to edit_htmladmin_managed_html_path(@managed_html.id), notice: "#{@managed_html.title}を作成しました"
    else
      flash.now[:alert] = "作成に失敗しました"
      set_imports
      render :new
    end
  end

  def update
    if @managed_html.update(managed_html_params)
      delete_insert_imports
      redirect_to edit_htmladmin_managed_html_path(@managed_html.id), notice: "#{@managed_html.title}を更新しました"
    else
      flash.now[:alert] = "更新に失敗しました"
      set_imports
      render :edit
    end
  end

  def destroy
    title = @managed_html.title
    @managed_html.destroy
    redirect_to htmladmin_root_path, notice: "#{title}を削除しました"
  end

  def page
    @managed_html = ManagedHtml.find_by(address: params[:id])
    check_public
    render 'show', layout: 'htmladmin/viewer'
  end

  private
    def set_managed_html
      @managed_html = ManagedHtml.find(params[:id])
    end
    
    def set_imports
      @import_js = current_user.managed_htmls.where.not("managed_htmls.js_note = ''")
      @import_css = current_user.managed_htmls.where.not("managed_htmls.css_note = ''")
    end

    def managed_html_params
      params.require(:managed_html).permit(:title, :note, :public, :level, :js_note, :css_note, :address)
    end
    
    def delete_insert_imports
      @managed_html.import_htmls.destroy_all
      params[:js].present? && params[:js].each do |i, js|
        @managed_html.import_htmls.create(import_html_id: js["id"], asset_type: "js") if js[:use]
      end
      params[:css].present? && params[:css].each do |i, css|
        @managed_html.import_htmls.create(import_html_id: css["id"], asset_type: "css") if css[:use]
      end
    end
    
    def check_public
      @managed_html.public || @managed_html.user_id == current_user.id
    end
end