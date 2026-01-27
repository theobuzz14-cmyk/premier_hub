class CreateReports < ActiveRecord::Migration[6.1]
  def change
    create_table :reports do |t|
      t.bigint :thread_id
      t.bigint :user_id, null: false
      t.bigint :comment_id
      t.text :reason, null: false
      t.integer :status, null: false, default: 0

      t.timestamps
    end
    add_index :reports, :thread_id
    add_index :reports, :user_id
    add_index :reports, :comment_id
  end
end
