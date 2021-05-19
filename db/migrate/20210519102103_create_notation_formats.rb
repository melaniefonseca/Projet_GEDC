class CreateNotationFormats < ActiveRecord::Migration[6.1]
  def change
    create_table :notation_formats do |t|
      t.string :contenu
      t.timestamps
    end
  end
end
