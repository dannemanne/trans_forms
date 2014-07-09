class NestedFormsModel
  include TransForms::NestedForms::Active

  # Makes the methods public for easier Unit testing
  public :each_nested_hash_for, :any_nested_hash_for?, :find_from!
end

class UserAndPoneNumbersCreator < TransForms::FormBase
  has_nested_forms

  attr_reader :user

  attribute :name,                      String
  attribute :phone_numbers_attributes,  Hash

  validates :name, presence: true

  transaction do
    @user = User.create!(name: name)

    each_nested_hash_for phone_numbers_attributes do |attr|
      @user.phone_numbers.create!(attr)
    end
  end

end
