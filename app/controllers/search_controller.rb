class SearchController < ApplicationController
  before_action :authenticate_user!

  def index
    @tasks = Task.search(params[:query], where: { user_id: current_user.id })
  end
end
