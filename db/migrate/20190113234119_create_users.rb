class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :name
      t.string :job_description
      t.integer :level
      t.references :location, foreign_key: true

      t.timestamps
    end
  end
end
