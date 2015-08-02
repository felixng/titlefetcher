class CreateQueries < ActiveRecord::Migration
  def change
    create_table :queries do |t|

      t.timestamps null: false
      t.text :url
    end
  end
end
