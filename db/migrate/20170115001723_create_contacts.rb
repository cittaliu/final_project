class CreateContacts < ActiveRecord::Migration[5.0]
  def change
    create_table :contacts do |t|
      t.belongs_to :company
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :phone
      t.string :linkedin_url
      t.string :position

      t.timestamps
    end
  end
end
