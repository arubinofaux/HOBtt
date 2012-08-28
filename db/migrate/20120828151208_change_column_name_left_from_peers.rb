class ChangeColumnNameLeftFromPeers < ActiveRecord::Migration
  def up
    change_table :peers do |t|
      t.rename :left, :leftt
    end
  end

  def down
    change_table :peers do |t|
      t.rename :leftt, :left
    end
  end
end
