class NoErrorInTransactionForm < TransForms::FormBase
  transaction do
    # Bunch of actions
    1 + 1; 'No errors'; [1,2,3].map(&:to_s)
    false # Can return false, save will be success anyway
  end
end

class ErrorInTransactionForm < TransForms::FormBase
  transaction do
    raise ActiveRecord::ActiveRecordError
  end
end

class RecordNotFoundInTransactionForm < TransForms::FormBase
  transaction do
    User.find 9999999
  end
end

class RecordNotSavedInTransactionForm < TransForms::FormBase
  transaction do
    user = User.new
    raise ActiveRecord::RecordNotSaved, ['Could not save the record', user]
  end
end

class RecordInvalidInTransactionForm < TransForms::FormBase
  transaction do
    User.new.save!
  end
end
