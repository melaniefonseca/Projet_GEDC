class AddRempliToNotations < ActiveRecord::Migration[6.1]
  def change
    add_column :notations, :rempli, :boolean
  end
end
