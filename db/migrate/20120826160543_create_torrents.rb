class CreateTorrents < ActiveRecord::Migration
  def change
    create_table :torrents do |t|
      t.string :info_hash

      t.timestamps
    end
  end
end
