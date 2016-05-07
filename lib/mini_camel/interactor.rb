module MiniCamel
  class Interactor
    include Virtus.value_object
    include ActiveModel::Validations

    def call
      raise InvalidInteractor, "Invalid interactor '#{self.class.name}': #{self.errors.full_messages}." if invalid?

      run
    end

  end
end
