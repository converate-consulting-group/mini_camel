module MiniCamel
  class ExchangeError
    include Virtus.value_object

    values do
      attribute :error_class, Class, reader: :private
      attribute :message, String, reader: :private
      attribute :details, Dto, reader: :private
    end

    attribute :backtrace, Array, default: []

    def on(check_error_class)
      yield message, details if check_error_class == error_class

      self
    end

    # This is just a helper method.
    # Do not use it in production code!
    def raise!
      raise ReRaisedError.new(message, error_class)
    end

    def as_json(options = {})
      {error_class: error_class.name, message: message, details: details}.as_json(options)
    end

    private

    def details
      @details ||= Dto.empty
    end

  end
end
