class MainModelModel
  include TransForms::MainModel
end

class UserUpdater < TransForms::FormBase
  set_main_model :user

  attribute :name,  String

  validates :name, presence: true

  transaction do
    user.attributes = { name: name }
    user.save!
  end

end
