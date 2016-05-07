module MiniCamel
  class Exchange
    include Virtus.value_object

    attribute :context, Context, reader: :private

    values do
      attribute :result, ExchangeResult, reader: :private
      attribute :error,  ExchangeError, reader: :private
    end

    def success?
      error.nil?
    end

    def failure?
      !success?
    end

    def on(modifier)
      raise ArgumentError, "Unkown modifier '#{modifier}'" unless modifier.in? [:success, :failure]

      yield result if modifier == :success && success?
      yield error  if modifier == :failure && failure?

      self
    end

    def result_or_else(fallback)
      if success?
        result
      else
        ExchangeResult.new(fallback)
      end
    end

    def result_or_else_nil
      result if success?
    end

    def result_or_else_fail!
      if success?
        result
      else
        raise ExchangeFailure.new("Exchange failed!", error)
      end
    end

    def result_or_else_try
      if success?
        result
      else
        yield error
      end
    end

    def update_context(params = {})
      context.update(params)
    end

    def context_fetch(field_name, default: nil)
      context.fetch(field_name, default: default)
    end

    def set_result(exchange_result)
      self.result = exchange_result
    end

    def set_error(exchange_error)
      self.error = exchange_error
    end

    private

    def context
      @context ||= Context.empty
    end

  end
end
