class CreateMails < ActiveRecord::Migration[5.0]
  def change
    create_table :mails do |t|
      t.string :date
      t.string :subject
      t.string :body
      t.string :from
      t.string :to

      t.timestamps
    end
  end
end
