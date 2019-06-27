# Object
class Object
  # Check that the object can be converted to a hash
  #
  # @param [Object] object
  #   The object to be checked
  def safe_to_h
    if respond_to?(:to_h)
      to_h
    else
      warn 'Value cannot be cast to hash. Returning original object'
      self
    end
  end
end
