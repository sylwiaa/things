class Task < ApplicationRecord
  belongs_to :project
  validates :content, presence: true

  searchkick
  scope :search_import, -> { includes(:project) }
  default_scope -> { order(:finished, :due_date) }

  scope :deleted, -> { where.not(deleted_at: nil) }
  scope :not_deleted, -> { where(deleted_at: nil) }
  scope :overdue, -> { where("due_date < ?", Time.now) }

  def search_data
    {
      content: content,
      user_id: project.user_id,
    }
  end

  def overdue?
    if due_date
      due_date < Date.today
    else
      false
    end
  end

  def today?
    due_date == Date.today
  end
end
