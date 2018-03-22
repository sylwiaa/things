class DashboardController < ApplicationController
  before_action :authenticate_user!
  def index
     @projects = current_user.projects.order("created_at DESC")
  end

end
