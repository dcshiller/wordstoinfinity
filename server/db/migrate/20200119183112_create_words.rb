class CreateWords < ActiveRecord::Migration[6.0]
  def change
    create_table :words do |t|
      t.references :player
      t.timestamps
    end
  end
end
