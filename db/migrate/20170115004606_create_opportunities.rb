class CreateOpportunities < ActiveRecord::Migration[5.0]
  def change
    create_table :opportunities do |t|
      t.belongs_to :user
      t.belongs_to :opening

      t.string :status
      t.float :priority
      t.timestamps
    end
  end
end
