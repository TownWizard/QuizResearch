class Publishers::WidgetsController < Publishers::BaseController
  layout 'publishers'
  before_filter :authorize_site_admin_access

  def index
    @widgets = Widget.all
  end

  def new
    @widget = Widget.new
  end

  def create
    @widget = Widget.new(params[:widget])
    if @widget.save
      flash[:notice] = "Successfully Created."
      redirect_to publishers_widgets_url
    else
      render :new
    end
  end

  def update_quiz_list
    @quizzes = Quiz.find(:all, :conditions => ['partner_id =?', params[:partner_id].to_i])
    p @quizzes
  end

  def edit
    @widget = Widget.find params[:id]
  end

  def update
    @widget = Widget.find params[:id]
    if @widget.update_attributes(params[:widget])
      flash[:notice] = "Successfully Updated."
      redirect_to publishers_widgets_url
    else
      render :edit
    end
  end

  def destroy
    @widget = Widget.find params[:id]
    if @widget.destroy
      redirect_to publishers_widgets_url
    end
  end
end
