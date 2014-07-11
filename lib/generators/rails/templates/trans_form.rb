<%- module_namespacing do -%>
  <%- if parent_class_name.present? -%>
class <%= class_name %> < <%= parent_class_name %>
  <%- else -%>
class <%= class_name %>
  <%- end -%>

  # Define the attributes available for this specific form model. The attributes
  # are declared according to the Virtus standard
  #
  #   attribute :name,      String
  #   attribute :age,       Numeric
  #   attribute :phone_no,  Array


  # Define validations according to the ActiveModel conventions
  #
  #   validates :name,  presence: true
  #   validates :age,   numericality: { greater_than_or_equal_to: 18 }

  transaction do
    # Perform all actions inside this block. If anything goes wrong, i.e. an
    # an error is raised because of validation errors, then everything that
    # has already been done inside this block is rolled back.
    #
    #   self.user = User.create!(name: name, age: age, phone_no: phone_no)

  end

end
<% end -%>
