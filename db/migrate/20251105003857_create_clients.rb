class CreateClients < ActiveRecord::Migration[7.2]
  def change
    create_table :clients do |t|
      t.string :name, null: false, limit: 200
      t.string :type_identification, limit: 10, default: 'NIT'
      t.string :identification, null: false, limit: 50
      t.string :email, null: false, limit: 100
      t.string :address
      t.integer :state, default: 1, null: false

      t.timestamps
    end
  end
end
