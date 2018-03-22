require 'rails_helper'

RSpec.describe Task, type: :model do
  let(:user) {FactoryBot.create(:user)}
  let(:project) {FactoryBot.create(:project, user: user)}

  it 'is valid with project and content' do
    task = Task.new(
      project: project,
      content: 'Task test contetnt'
    )
    expect(task).to be_valid
  end

  describe '#overdue?' do

    it 'returns false if due_date is empty' do
      task = FactoryBot.create(:task, due_date: nil)
      expect(task.overdue?).to eq(false)
    end

    it 'returns true if due_date is before now' do
      task = FactoryBot.create(:task, due_date: 2.day.ago)
      expect(task.overdue?).to eq(true)
    end

    it 'returns false if due_date is after now' do
      task = FactoryBot.create(:task, due_date: 1.day.from_now)
      expect(task.overdue?).to eq(false)
    end

    it 'returns false if due_date is today' do
      task = FactoryBot.create(:task, due_date: Date.today)
      expect(task.overdue?).to eq(false)
    end
  end

  describe '#today?' do

    it 'returns false if due_date is empty' do
      task = FactoryBot.create(:task, due_date: nil)
      expect(task.today?).to eq(false)
    end

    it 'returns false if due_date is before now' do
      task = FactoryBot.create(:task, due_date: 1.day.ago)
      expect(task.today?).to eq(false)
    end

    it 'returns false if due_date is after now' do
      task = FactoryBot.create(:task, due_date: 1.day.from_now)
      expect(task.today?).to eq(false)
    end

    it 'returns true if due_date is today' do
      task = FactoryBot.create(:task, due_date: Date.today)
      expect(task.today?).to eq(true)
    end
  end
end
