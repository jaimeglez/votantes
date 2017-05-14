class Admin::DashboardsController < Admin::AdminBaseController
  def show
    @zones = Zone.all
    @sections = Section.all
    @squares = Square.all
    @voters = Voter.all
  end

  def chart
    type = params[:type]
    parent = params[:parent] ||= ''
    @chartLabels, @chartData = type.classify.constantize.build_chart(parent)
    respond_to do |format|
        format.js
    end
  end
end
