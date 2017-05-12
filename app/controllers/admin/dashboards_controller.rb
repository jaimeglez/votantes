class Admin::DashboardsController < Admin::AdminBaseController
  def show
    @zonesLabels, @zonesData = Zone.build_chart
  end
end
