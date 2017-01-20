class CreateCompanies < ActiveRecord::Migration[5.0]
  def change
    create_table :companies do |t|
      t.string :linkedin_id
      t.string :kind
      t.string :name
      t.string :linkedin_url
      t.string :industry
      t.string :city
      t.string :state
      t.string :country
      t.string :size
      t.string :website
      t.string :description

      t.timestamps
    end
  end
end
