class FixColumnName < ActiveRecord::Migration[6.1]
  def change
    rename_column :evaluations, :auto_evalution, :auto_evaluation
  end
end
