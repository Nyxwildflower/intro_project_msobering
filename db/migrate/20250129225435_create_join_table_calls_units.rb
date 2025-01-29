class CreateJoinTableCallsUnits < ActiveRecord::Migration[7.1]
  def change
    create_join_table :calls, :units, :id => false do |t|
      # t.index [:call_id, :unit_id]
      # t.index [:unit_id, :call_id]
    end
  end
end
