class CreateImportationTasks < ActiveRecord::Migration
  def change
    create_table :importation_tasks do |t|
      t.string :task_code, :null => false

      t.timestamps
    end
  end
end
