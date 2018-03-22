require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  render_views

  before do
    @user = FactoryBot.create(:user)
    @project = FactoryBot.create(:project, user: @user)
  end

  describe '#create' do
    it 'adds new task to the project' do
      new_task = { content: 'New test task' }
        sign_in @user
        expect {
          post :create,
          params: { project_id: @project.id, task: new_task}
        }.to change(@project.tasks, :count).by(1)
    end

    it 'requires authentication' do
      new_task = { contetnt: 'New test task' }
      expect {
        post :create,
        params: { project_id: @project.id, task: new_task }
      }.to_not change(@project.tasks, :count)
      expect(response).to_not be_success
    end
  end

  describe '#update' do
    context 'as an authenticated user' do
      before do
        sign_in @user
        @project = FactoryBot.create(:project, user: @user)
        @task = FactoryBot.create(:task, project: @project)
      end

      it 'updates a task' do
        task_params = FactoryBot.attributes_for(:task, content: 'Task test')
        patch :update,
              params: { id: @task.id, project_id: @project.id, task: task_params }, format: :js
        expect(@task.reload.content).to eq 'Task test'

      end
    end

    context 'as an unauthenticated user' do
    end
  end

  describe '#destroy' do
    context 'as an authenticated user' do
      before do
        sign_in @user
        @project = FactoryBot.create(:project, user: @user)
        @task = FactoryBot.create(:task, project: @project)
      end

      it 'does not delete task from database' do
        expect(Task.count).to eq(1)
        expect(Task.not_deleted.count).to eq(1)
        expect(Task.deleted.count).to eq(0)

        delete :destroy, params: { id: @task.id, project_id: @project.id }

        expect(Task.not_deleted.count).to eq(0)
        expect(Task.count).to eq(1)
        expect(Task.deleted.count).to eq(1)
      end

      it 'deletes from database when used twice' do
        expect(Task.count).to eq(1)
        expect(Task.not_deleted.count).to eq(1)
        expect(Task.deleted.count).to eq(0)

        delete :destroy, params: { id: @task.id, project_id: @project.id }
        delete :destroy, params: { id: @task.id, project_id: @project.id }

        expect(Task.count).to eq(0)
        expect(Task.not_deleted.count).to eq(0)
        expect(Task.deleted.count).to eq(0)
      end
    end
  end
end
