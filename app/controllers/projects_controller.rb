class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_show_projects_sidebar

  def index
    @projects = current_user.projects.order(:title)
  end

  def new
    @project = Project.new(user: current_user)
  end

  def create
    @project = current_user.projects.new(project_params)

   if @project.save
     redirect_to action: 'index', flash: { notice: 'Created a new task' }
   else
     render :new
   end
  end

  def show
    @project = current_user.projects.find(params[:id])
    @tasks = @project.tasks.not_deleted
  end

  def update
    @project = current_user.projects.find(params[:id])
    @project.update(project_params)
    if @project.save
      redirect_to action: 'show'
    else
      render :edit
    end
  end

  def edit
    @project = current_user.projects.find(params[:id])
  end

  def destroy
    @project = current_user.projects.find(params[:id])
    @project.destroy
    redirect_to action: 'index'
  end

  private

  def project_params
    params.require(:project).permit(:title, :body)
  end

  def set_show_projects_sidebar
    @show_projects_sidebar = true
  end
end
