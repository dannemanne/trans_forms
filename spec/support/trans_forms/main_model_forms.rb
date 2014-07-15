class MainModelModel
  include TransForms::MainModel
end

class ProxyModel
  class_attribute :main_model
  self.main_model = :user
  include TransForms::MainModel::Proxy
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

class UserProxyModel < TransForms::FormBase
  set_main_model :user, proxy: true
end
