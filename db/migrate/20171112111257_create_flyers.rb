class CreateFlyers < ActiveRecord::Migration[5.0]
  def change
    create_table :flyers do |t|
      t.integer :event_id
      t.string :image

      t.timestamps
    end
  end
end
