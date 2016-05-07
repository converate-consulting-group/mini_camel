module MiniCamel

  # A StrictDTO is stricter than a common open struct object.
  # It will throw an argument error if the key / method you ask for does not exist.
  class StrictDto < Dto

    def [](key)
      fetch(key)
    end

    def fetch(key, default: nil)
      if @table.has_key?(key)
        @table.fetch(key, default)
      else
        return default unless default.nil?
        raise_key_not_found!(key)
      end
    end

    def method_missing(method_name, *arguments, &block)
      if respond_to?(method_name) || method_name.to_s.end_with?('=')
        super
      else
        raise_key_not_found!(method_name)
      end
    end

    private

    def raise_key_not_found!(key)
      raise ArgumentError, "Method or key '#{key}' not found! Available keys: #{keys.join(', ')}"
    end

  end

end
