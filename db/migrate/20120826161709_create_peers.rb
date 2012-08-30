class CreatePeers < ActiveRecord::Migration
  def change
    create_table :peers do |t|
      t.string :peer_id
      t.string :ip
      t.integer :port

      t.timestamps
    end
  end
end
