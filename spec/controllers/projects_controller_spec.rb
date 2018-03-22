require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
  render_views

  before do
    @user = FactoryBot.create(:user)
  end

  describe '#index' do
    context 'unauthenticated user' do
      it 'returns a 302 response' do
        get :index
        expect(response).to have_http_status '302'
      end

      it 'user should be redirected' do
        get :index
        expect(response).to redirect_to '/users/sign_in'
      end
    end

    context 'authenticated user' do
      before do
        sign_in @user
      end

      it 'should not be redirected' do
        get :index

        expect(response).to be_ok
      end

      it 'should see projects created' do
        FactoryBot.create(:project, title: 'Test1', user: @user)
        FactoryBot.create(:project, title: 'Test2')

        get :index

        expect(response).to be_ok

        expect(response.body).to match(/Test1/)
        expect(response.body).not_to match(/Test2/)
      end
    end
  end

  describe '#show' do
    context 'as an authorized user' do
      before do
        sign_in @user
        @project = FactoryBot.create(:project, user: @user)
      end

      it 'responds successfully' do
        get :show, params: { id: @project.id }
        expect(response).to be_success
      end
    end

    context 'as an unauthorized user' do
      before do
        @project = FactoryBot.create(:project)
      end

      it 'returns 302 response' do
        project_params = FactoryBot.attributes_for(:project)
        patch :update, params: { id: @project.id, project: project_params }
        expect(response).to have_http_status '302'
      end

      it 'redirects to the sign-in page' do
        project_params = FactoryBot.attributes_for(:project)
        patch :update, params: { id: @project.id, project: project_params }
        expect(response).to redirect_to '/users/sign_in'
      end
    end
  end

  describe '#create' do
    context 'as an authenticated user' do
      before do
        sign_in @user
      end
      it 'adds a project' do
        project_params = FactoryBot.attributes_for(:project)
        expect {
           post :create, params: { project: project_params }
        }.to change(@user.projects, :count).by(1)
      end
    end

    context 'as an unauthorized user' do
      it 'returns a 302 response' do
        project_params = FactoryBot.attributes_for(:project)
        post :create, params: { project: project_params }
        expect(response).to have_http_status '302'
      end

      it 'redirects to the sign-in page' do
        project_params = FactoryBot.attributes_for(:project)
        post :create, params: { project: project_params }
        expect(response).to redirect_to '/users/sign_in'
      end
    end
  end

  describe '#update' do
    context 'as an authenticated user' do
      before do
        sign_in @user
        @project = FactoryBot.create(:project, user: @user)
      end

      it 'updates a title project' do
        project_params = FactoryBot.attributes_for(:project,
          title: "Test")

        patch :update, params: { id: @project.id, project: project_params }
        expect(@project.reload.title).to eq 'Test'
      end

       it 'updates a body project' do
        project_params = FactoryBot.attributes_for(:project,
          body: "New test body")

        patch :update, params: { id: @project.id, project: project_params }
        expect(@project.reload.body).to eq 'New test body'
       end
    end

    context 'as an unauthorized user' do
      before do
        @project = FactoryBot.create(:project)
      end

      it 'returns 302 response' do
        project_params = FactoryBot.attributes_for(:project)
        patch :update, params: { id: @project.id, project: project_params }
        expect(response).to have_http_status '302'
      end

      it 'redirects to the sign-in page' do
        project_params = FactoryBot.attributes_for(:project)
        patch :update, params: { id: @project.id, project: project_params }
        expect(response).to redirect_to '/users/sign_in'
      end
    end
  end

  describe '#destroy' do
    context 'as an authenticated user' do
      before do
        sign_in @user
        @project = FactoryBot.create(:project, user: @user)
      end

      it 'deletes a project' do
        expect {
          delete :destroy, params: { id: @project.id }
        }.to change(@user.projects, :count).by(-1)
      end
    end

    context 'as an unauthorized user' do
      before do
        @project = FactoryBot.create(:project)
      end

      it 'returns a 302 response' do
        delete :destroy, params: { id: @project.id }
        expect(response).to have_http_status '302'
      end

      it 'redirects to the sign-in page' do
        delete :destroy, params: { id: @project.id }
        expect(response).to redirect_to '/users/sign_in'
      end

      it 'does not delete the project' do
        expect {
          delete :destroy, params: { id: @project.id }
        }.to_not change(Project, :count)
      end
    end
  end
end
