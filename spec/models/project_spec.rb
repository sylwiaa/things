require 'rails_helper'

RSpec.describe Project, type: :model do
  let(:user) {FactoryBot.create(:user)}

  it 'is valid with user and title' do
    project = Project.new(
      user: user,
      title: 'Project title'
    )
    expect(project).to be_valid
  end

  it 'is invalid without a title and body' do
    project = Project.new(title: nil)

    project.valid?
    expect(project.errors[:title]).to include("can't be blank")
  end

end
