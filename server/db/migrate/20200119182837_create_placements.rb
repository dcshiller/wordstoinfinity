class CreatePlacements < ActiveRecord::Migration[6.0]
  def change
    create_table :placements do |t|
      t.integer :x, index: true
      t.integer :y, index: true
      t.string :value
      t.references :move

      t.timestamps
    end
    add_index :placements, [:x, :y], unique: true
  end
end
