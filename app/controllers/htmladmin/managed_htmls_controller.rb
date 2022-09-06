class Htmladmin::ManagedHtmlsController < HtmladminController
  skip_before_action :authenticate_user!, :only => [:show, :page]
  before_action :set_managed_html, only: [:show, :edit, :update, :destroy, :edit_source, :update_source]
  before_action :set_html, only: [:show, :edit_source, :update_source]
  before_action :check_public, :only => [:show]

  layout 'htmladmin/main'

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
    @managed_html = ManagedHtml.new(managed_html_params)
    if @managed_html.save
      @js = ::ManagedJs.create(managed_html_id: @managed_html.reload.id)
      @css = ::ManagedCss.create(managed_html_id: @managed_html.id)
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
    redirect_to "/", notice: "#{title}を削除しました"
  end
  
  def edit_source
    render :layout => 'htmladmin/editor'
  end
  
  def update_source
    ActiveRecord::Base.transaction do
      @managed_html.body = source_params[:html]
      @managed_html.yaml = source_params[:yaml]
      @managed_html.use_yaml = source_params[:use_yaml]
      @js.body = source_params[:js]
      @css.body = source_params[:css]
      @managed_html.save!
      @js.save!
      @css.save!
    end
    redirect_to edit_source_htmladmin_managed_html_path(@managed_html.id), notice: "保存しました"
  rescue
    flash.now[:alert] = "保存に失敗しました"
    render :edit_source, :layout => 'editor'
  end

  def page
    @managed_html = ManagedHtml.find_by(address: params[:id])
    check_public
    set_html
    render 'show', layout: 'htmladmin/viewer'
  end

  private
    def set_managed_html
      @managed_html = ManagedHtml.find(params[:id])
    end
    
    def set_imports
      @import_js = ManagedJs.eager_load(:managed_html)
                            .where("managed_htmls.user_id = ?", current_user.id)
                            .where.not("managed_htmls.js_note = ''")
      @import_js = @import_js.where.not(id: @managed_html.managed_js.id) if @managed_html.managed_js
      @import_css = ManagedCss.eager_load(:managed_html)
                              .where("managed_htmls.user_id = ?", current_user.id)
                              .where.not("managed_htmls.css_note = ''")
      @import_css = @import_css.where.not(id: @managed_html.managed_css.id) if @managed_html.managed_css
    end

    def managed_html_params
      @use_js = params[:import_js]
      @use_css = params[:import_css]
      params.require(:managed_html).permit(
        :title, :note, :public, :level, :js_note, :css_note, :import_js, :import_css,
        :sample, :readme, :address,
        images_attributes: [:id, :image, :image_cache, :_destroy]
      ).tap do |v|
        v[:user_id] = current_user.id
        v[:public] = false if v[:public].nil?
        v[:sample] = false if !current_user.admin? || v[:sample].nil?
        v[:readme] = false if !current_user.admin? || v[:readme].nil?
        v[:level] ||= 100
      end
    end
    
    def source_params
      params.permit(:html, :js, :css, :yaml, :use_yaml)
    end
    
    def set_html
      @js = @managed_html.managed_js || ::ManagedJs.new(managed_html_id: @managed_html.id)
      @css = @managed_html.managed_css || ::ManagedCss.new(managed_html_id: @managed_html.id)
    end
    
    def delete_insert_imports
      ::JsImport.where(managed_html_id: @managed_html.id).delete_all
      ::CssImport.where(managed_html_id: @managed_html.id).delete_all
      @use_js.each do |k, js|
        if js[:use] == "true"
          ::JsImport.create(managed_html_id: @managed_html.id, managed_js_id: js[:id].to_i)
        end
      end if @use_js
      @use_css.each do |k, css|
        if css[:use] == "true"
          ::CssImport.create(managed_html_id: @managed_html.id, managed_css_id: css[:id].to_i)
        end
      end if @use_css
    end
    
    def check_public
      user_logged_in? unless @managed_html.public
    end
end