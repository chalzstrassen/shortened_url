class AddTimeStampsToVisit < ActiveRecord::Migration
  def change
    add_timestamps(:visits)
  end
end
