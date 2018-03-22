class Project < ApplicationRecord
  belongs_to :user
  has_many :tasks
  validates :title, presence: true

  searchkick

  def search_data
    { title: title,
      body: body }
  end
end
