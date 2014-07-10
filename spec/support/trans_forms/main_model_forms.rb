class MainModelModel
  include TransForms::MainModel
end

class UserUpdater < TransForms::FormBase
  set_main_models :user

  attribute :name,  String

  validates :name, presence: true

  transaction do
    user.attributes = { name: name }
    user.save!
  end

end

class MultipleRecordsMainModel < TransForms::FormBase
  set_main_models :user, :phone_number
end
