class CallbackForm < TransForms::FormBase
  attr_reader :user1, :user2, :i_was_called

  attribute :name1,      String
  attribute :name2,      String

  validates :name1, presence: true
  validates :name2, presence: true

  after_save_on_error :call_me

  transaction do
    @user1 = User.create!(name: name1)
    @user2 = User.create!(name: name2)
  end

protected
  def call_me(error)
    @i_was_called = true
  end

end
