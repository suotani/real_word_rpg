class Htmladmin::UsersController < HtmladminController
  before_action :set_user, only: [:show]
  layout 'htmladmin/main'

  def index
  end

  def show
    if params[:research].blank? && session[:search_filter].present?
      @filter = session[:search_filter].with_indifferent_access
    else
      @filter = { level: params[:level], tag: params[:tag], title: params[:title], sort: params[:sort], order: params[:order] }
    end
    session[:search_filter] = @filter
    order = @filter[:order] == "desc" ? :desc : :asc
    @managed_htmls = @user.managed_htmls
    @managed_htmls = @managed_htmls.where(level: @filter[:level]) if @filter[:level].present?
    @managed_htmls = @managed_htmls.where("title LIKE '%#{@filter[:title]}%'")  if @filter[:title].present?
    @managed_htmls = @managed_htmls.order(level: order) if @filter[:sort] == "level"
    @managed_htmls = @managed_htmls.order(created_at: order) if @filter[:sort].nil? || @filter[:sort] == "created_at"
    @managed_htmls = @managed_htmls.order(updated_at: order) if @filter[:sort] == "updated_at"
    @managed_htmls = @managed_htmls.order(title: order) if @filter[:sort] == "title"
    @managed_htmls = @managed_htmls.page(params[:page])
  end

  private
    def set_user
      @user = User.find(params[:id])
    end
end
