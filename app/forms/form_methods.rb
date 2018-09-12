module FormMethods

  # Not happy that I have to write this myself, but rails relies on database inspection to autopopulate model attrs... which I don't have here!

  def attributes
    attrs = {}
    attributes_list.each do |attribute_name|
      attrs[attribute_name] = instance_variable_get "@#{attribute_name}"
    end

    attrs
  end

  def assign_attributes (attributes)
    attributes_list.each do |attribute_name|
      instance_variable_set "@#{attribute_name}", attributes[attribute_name]
    end
  end

  def inspect
    ap attributes
  end

end