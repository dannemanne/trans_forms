class ApplicationTransForm < TransForms::FormBase
  # Here you can place application specific code to customize the
  # default behavior of TransForms.
  #
  # Here is an example of a custom instantiator that works to set
  # a model and current_user attributes in addition to the params
  # which might come directly from the controller.
  #
  #   def self.new_in_model(model, params = {}, current_user = nil)
  #     new(params.merge(model: model, current_user: current_user))
  #   end

end
