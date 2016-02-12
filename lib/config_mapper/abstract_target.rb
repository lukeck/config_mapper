module ConfigMapper

  # Something that accepts configuration.
  #
  class AbstractTarget

    # Map configuration data onto the target.
    #
    # @return [Hash] exceptions encountered
    #
    def configure_with(data)
      errors = {}
      data.each do |key, value|
        set_attribute(key, value, errors)
      end
      errors
    end

    private

    # Set a single attribute.
    #
    def set_attribute(key, value, errors)
      attribute_path = path(key)
      if value.is_a?(Hash) && !get(key).nil?
        nested_errors = ConfigMapper.set(value, get(key))
        nested_errors.each do |nested_path, error|
          errors["#{attribute_path}#{nested_path}"] = error
        end
      else
        set(key, value)
      end
    rescue NoMethodError, ArgumentError => e
      errors[attribute_path] = e
    end

  end

end
