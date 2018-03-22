require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  render_views
  let(:user) { FactoryBot.create(:user) }
  let(:project) { FactoryBot.create(:project, user: user) }
  describe '#index' do
    before do
      sign_in user
    end

    it 'returns tasks created by user' do
      FactoryBot.create(:task, content: 'Task aaa', project: project)
      Task.search_index.refresh

      get :index, params: { query: 'aaa' }
      expect(response.body).to match(/Task aaa/)
    end

    it 'does not return tasks created by another user' do
      FactoryBot.create(:task, content: 'Task aaa')
      Task.search_index.refresh

      get :index, params: { query: 'aaa' }
      expect(response.body).not_to match(/Task aaa/)
    end
  end
end
