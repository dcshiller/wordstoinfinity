class CreateLetters < ActiveRecord::Migration[6.0]
  def change
    create_table :letters do |t|
      t.integer :x, index: true
      t.integer :y, index: true
      t.string :value
      t.references :word

      t.timestamps
    end
    add_index :letters, [:x, :y], unique: true
  end
end
