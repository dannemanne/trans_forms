class MultipleRecordsCreator < TransForms::FormBase
  attr_reader :user1, :user2

  attribute :name1,      String
  attribute :name2,      String

  validates :name1, presence: true
  validates :name2, presence: true

  transaction do
    @user1 = User.create!(name: name1)
    @user2 = User.create!(name: name2)
  end

end

class MultipleRecordsCreatorNoBang < TransForms::FormBase
  attr_reader :user1, :user2

  attribute :name1,      String
  attribute :name2,      String

  validates :name1, presence: true
  validates :name2, presence: true

  transaction do
    @user1 = User.create(name: name1)
    @user2 = User.create(name: name2)
  end

end
