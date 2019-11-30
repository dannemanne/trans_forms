class MainModelModel
  include TransForms::MainModel
end

class ProxyModel
  include TransForms::MainModel::Proxy
  self.main_model = :user
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

  transaction do
    # Will raise error if User model is not valid
    user.save!
  end
end

class UserProxyAllModel < TransForms::FormBase
  ATTR_ARG = :all
  set_main_model :user, proxy: { attributes: ATTR_ARG }
end

class UserProxySelectModel < TransForms::FormBase
  ATTR_ARG = %w(name)
  set_main_model :user, proxy: { attributes: ATTR_ARG }
end
