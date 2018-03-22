class CreateTasks < ActiveRecord::Migration[5.1]
  def change
    create_table :tasks do |t|
      t.integer :project_id
      t.string :content
      t.boolean :finished, default: false
      t.date :due_date

      t.timestamps
    end
  end
end
