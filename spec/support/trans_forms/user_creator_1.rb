class UserCreator1 < TransForms::FormBase
  attr_reader :user

  attribute :name,      String
  attribute :age,       Numeric

  attr_accessor :extra_attribute

  validates :name, presence: true

  transaction do
    @user = User.create!(name: name, age: age)
  end

end
