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

class UserProxyAllModel < TransForms::FormBase
  ATTR_ARG = :all
  set_main_model :user, proxy: { attributes: ATTR_ARG }
end

class UserProxySelectModel < TransForms::FormBase
  ATTR_ARG = %w(name)
  set_main_model :user, proxy: { attributes: ATTR_ARG }
end
