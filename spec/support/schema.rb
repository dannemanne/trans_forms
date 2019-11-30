require 'active_record'

ActiveRecord::Base.establish_connection({
    adapter: 'sqlite3',
    database: ':memory:'
})

# prepare test data
ActiveRecord::Schema.define do
  self.verbose = false

  create_table "users", :force => true do |t|
    t.string "name"
    t.integer "age"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "phone_numbers", :force => true do |t|
    t.integer "user_id"
    t.string "number"
  end
end
