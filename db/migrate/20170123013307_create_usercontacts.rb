class CreateUsercontacts < ActiveRecord::Migration[5.0]
  def change
    create_table :usercontacts do |t|
      t.belongs_to :contact
      t.belongs_to :user

      t.timestamps
    end
  end
end
