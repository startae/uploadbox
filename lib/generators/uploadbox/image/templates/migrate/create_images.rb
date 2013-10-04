class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :file
      t.references :imageable, polymorphic: true, index: true
      t.integer :width
      t.integer :height
      t.boolean :retina, default: false
      t.string :upload_name
      t.string :secure_random, index: true

      t.timestamps
    end
  end
end
