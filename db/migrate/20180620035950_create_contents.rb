class CreateContents < ActiveRecord::Migration[5.1]
  def change
    create_table :contents do |t|
      t.text :url, null: false

      t.timestamps
    end
  end
end
