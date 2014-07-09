class User < ActiveRecord::Base
  has_many :phone_numbers, dependent: :destroy

  validates :name, presence: true, uniqueness: true
end

class PhoneNumber < ActiveRecord::Base
  belongs_to :user

  validates :user_id, presence: true
  validates :number,  presence: true, uniqueness: { scope: :user_id }
end
