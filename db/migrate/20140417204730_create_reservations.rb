class CreateReservations < ActiveRecord::Migration
  def change
    create_table :reservations do |t|
      t.datetime  :start_time
      t.datetime  :end_time
      t.integer :table_number
    end
  end
end
