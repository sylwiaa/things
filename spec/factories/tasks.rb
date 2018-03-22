FactoryBot.define do
  factory :task do
    project
    content 'New test task.'
    finished false
    due_date 1.day.ago
  end
end
