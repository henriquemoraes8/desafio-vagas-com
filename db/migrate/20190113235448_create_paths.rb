class CreatePaths < ActiveRecord::Migration[5.2]
  def change
    create_table :paths do |t|
      t.references :location1, foreign_key: {to_table: :locations}
      t.references :location2, foreign_key: {to_table: :locations}
      t.integer :distance

      t.timestamps
    end
  end
end
