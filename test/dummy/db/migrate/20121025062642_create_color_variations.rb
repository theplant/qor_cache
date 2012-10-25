class CreateColorVariations < ActiveRecord::Migration
  def change
    create_table :color_variations do |t|
      t.string :name
      t.string :code
      t.string :product_code

      t.timestamps
    end
  end
end
