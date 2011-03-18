if !ActiveRecord::Base.private_method_defined? :update_without_callbacks
  def update_without_callbacks
    attributes_with_values = arel_attributes_values(false, false, attribute_names)
    return false if attributes_with_values.empty?
    self.class.unscoped.where(self.class.arel_table[self.class.primary_key].eq(id)).arel.update(attributes_with_values)
  end
end