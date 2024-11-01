class CreateEndpoints < ActiveRecord::Migration[7.2]
  def change
    create_table :endpoints do |t|
      t.string :verb
      t.string :path
      t.integer :response_code
      t.json :response_headers
      t.text :response_body

      t.timestamps
    end
  end
end
