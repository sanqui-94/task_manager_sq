class CreateTasks < ActiveRecord::Migration[8.1]
  def change
    create_table :tasks, id: :uuid do |t|
      t.string :code, null: false
      t.string :title, null: false
      t.text :description
      t.integer :status, null: false, default: 0
      t.integer :priority, null: false, default: 1
      t.boolean :archived, null: false, default: false
      t.datetime :archived_at
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    add_index :tasks, :code, unique: true
    add_index :tasks, [ :user_id, :status, :archived ]
  end
end
