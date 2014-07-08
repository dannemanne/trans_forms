
require 'active_record/errors'
module TransForms

  class NotImplementedError < StandardError
  end

  # Custom error class to distinguish from regular ActiveRecord not found errors, but
  # will trigger the same effect when raised within a transaction.
  class NotFoundFromError < ActiveRecord::RecordNotFound
  end

end
