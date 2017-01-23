class CreateTasks < ActiveRecord::Migration[5.0]
  def change
    create_table :tasks do |t|
      t.belongs_to :contact
      t.belongs_to :user

      t.string :summary
      t.string :location
      t.string :start
      t.string :end
      t.string :description

      t.timestamps
    end
  end
end
