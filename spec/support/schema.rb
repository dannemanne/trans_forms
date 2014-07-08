require 'active_record'

ActiveRecord::Base.establish_connection({
    adapter: 'sqlite3',
    database: ':memory:'
})

# prepare test data
class CreateTestSchema < ActiveRecord::Migration
  def change
    create_table "users", :force => true do |t|
      t.string "name"
      t.integer "age"
    end
  end
end

CreateTestSchema.migrate(:up)
