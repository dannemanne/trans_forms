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
