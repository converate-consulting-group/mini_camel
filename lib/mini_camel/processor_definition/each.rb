module MiniCamel
  module ProcessorDefinition
    class Each < Base

      values do
        attribute :field, Symbol
        validates :field, presence: true

        attribute :in_field, Symbol
        validates :in_field, presence: true

        attribute :additional_fields, [Symbol]

        attribute :with_class, Class
        validates :with_class, presence: true
      end

    end
  end
end
