class CreateLeagues < ActiveRecord::Migration[6.1]
  def change
    create_table :leagues do |t|
      t.string :name
      t.integer :min_participants
      t.integer :max_participants
      t.string :competition

      t.timestamps
    end
  end
end
