class CreateAuths < ActiveRecord::Migration[5.1]
  def change
    create_table :auths do |t|
      t.references :user,     foreign_key: true
      t.string :uid,          null: false
      t.string :provider,     null: false
      t.string :token,        null: false
      t.string :secret_token, null: false
      t.string :expires_at
      t.boolean :destination, null: false, default: false
      t.datetime :save_at

      t.timestamps
    end

    add_index :auths, [:uid, :provider], :unique => true
  end
end
