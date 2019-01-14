class CreateJobs < ActiveRecord::Migration[5.2]
  def change
    create_table :jobs do |t|
      t.string :description
      t.string :company
      t.string :title
      t.references :location, foreign_key: true
      t.integer :level

      t.timestamps
    end
  end
end
