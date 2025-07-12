class Htmladmin::SourcesController < Htmladmin::HtmladminController
  layout 'htmladmin/editor'

  before_action :set_managed_html

  def edit
  end

  def update
    if @managed_html.update(source_params)
      redirect_to edit_htmladmin_source_path(@managed_html.id), notice: "保存しました"
    else
      flash.now[:alert] = "保存に失敗しました"
      render :edit
    end
  end

  private

  def set_managed_html
    @managed_html = ManagedHtml.find(params[:id])
  end

  def source_params
    params.require(:managed_html).permit(:body, :js_body, :css_body, :yaml, :use_yaml)
  end
end
