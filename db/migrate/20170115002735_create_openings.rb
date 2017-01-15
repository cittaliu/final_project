class CreateOpenings < ActiveRecord::Migration[5.0]
  def change
    create_table :openings do |t|
      t.belongs_to :company
      t.string :name
      t.string :description
      t.boolean :status

      t.timestamps
    end
  end
end
