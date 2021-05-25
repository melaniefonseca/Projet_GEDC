class AddRempliToEvaluations < ActiveRecord::Migration[6.1]
  def change
    add_column :evaluations, :rempli, :boolean
  end
end
