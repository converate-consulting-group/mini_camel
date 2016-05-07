module MiniCamel
  class DefaultErrorHandler
    include Virtus.value_object

    values do
      attribute :registered_errors, Array, default: []
    end

    def call(error, exchange)
      raise error unless error.class.in? registered_errors

      exchange.set_error(assemble_exchange_error(error))
    end

    private

    def assemble_exchange_error(error)
      ExchangeError.new(
        error_class: error.class,
        message: error.message,
        details: Dto.new(details(error)),
        backtrace: error.backtrace || []
      )
    end

    def details(error)
      if error.respond_to?(:internal_errors)
        error.internal_errors
      else
        {}
      end
    end


  end
end

