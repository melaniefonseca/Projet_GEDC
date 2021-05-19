class CreateNotations < ActiveRecord::Migration[6.1]
  def change
    create_table :notations do |t|
      t.string :note
      t.string :commentaire
      t.integer :stage_id
      t.integer :notation_format_id
    end
    add_foreign_key :notations, :stages
    add_foreign_key :notations, :notation_formats
  end
end
