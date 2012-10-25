class CreateSmsReceiveds < ActiveRecord::Migration
  def change
    create_table :sms_receiveds do |t|
      t.string :from
      t.datetime :sent
      t.string :body

      t.timestamps
    end
  end
end
