class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project, except: [:overdue, :trash]

  def new
    @task = @project.tasks.new
  end

  def create
    @task = @project.tasks.new(task_params)
    if @task.save
      redirect_to project_path(@project)
    else
      render :new
    end
  end

  def update
    @task = @project.tasks.find(params[:id])
    @task.update(task_params)

    respond_to do |format|
      format.js
    end
  end

  def edit
    @task = @project.tasks.find(params[:id])
  end

  def destroy
    @task = @project.tasks.find(params[:id])

    if @task.deleted_at
      @task.destroy
      redirect_to trash_tasks_path
    else
      @task.deleted_at = Time.now
      @task.save
      redirect_to project_path(@project)
    end
  end

  def overdue
    @tasks = Task.not_deleted.overdue.includes(:project).where(projects: { user_id: current_user.id })
  end

  def trash
    @tasks = Task.deleted.includes(:project).where(projects: { user_id: current_user.id })
  end

  private

  def task_params
    params.require(:task).permit(:content, :due_date, :finished)
  end

  def set_project
    @project = current_user.projects.find(params[:project_id])
  end
end
