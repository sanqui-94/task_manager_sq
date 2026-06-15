class CreateTaskCodeSequences < ActiveRecord::Migration[8.1]
  def change
    create_table :task_code_sequences, id: false do |t|
      t.string :prefix, null: false, primary_key: true
      t.integer :last_number, null: false, default: 0
    end
  end
end
