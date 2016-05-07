module MiniCamel
  class RouteDefinition
    include Virtus.value_object
    include ActiveModel::Validations

    values do
      attribute :route_name, Symbol
      validates :route_name, presence: true

      attribute :description, String
      validates :description, presence: true

      attribute :processor_definitions, Array, default: []
      validates :processor_definitions, presence: true
    end

    def from(route_name)
      self.route_name = route_name
    end

    def desc(description)
      self.description = description
      self
    end

    def to(route)
      definition = ProcessorDefinition::To.new(route: route)

      add_processor_definition(definition)

      self
    end

    def pipeline(*routes)
      definition = ProcessorDefinition::Pipeline.new(routes: routes)

      add_processor_definition(definition)

      self
    end

    def process(*fields, **options)
      definition = ProcessorDefinition::Process.new(options.merge(fields: fields))

      add_processor_definition(definition)

      self
    end

    def process_each(field, **options)
      options[:in_field] = options.delete(:in)
      definition = ProcessorDefinition::ProcessEach.new(options.merge(field: field))

      add_processor_definition(definition)

      self
    end

    def transform(*fields, **options)
      definition = ProcessorDefinition::Transform.new(options.merge(fields: fields))

      add_processor_definition(definition)

      self
    end

    def transform_each(field, **options)
      options[:in_field] = options.delete(:in)
      definition = ProcessorDefinition::TransformEach.new(options.merge(field: field))

      add_processor_definition(definition)

      self
    end

    def mutate(field, **options)
      definition = ProcessorDefinition::Mutate.new(options.merge(field: field))

      add_processor_definition(definition)

      self
    end

    def mutate_each(field, **options)
      options[:in_field] = options.delete(:in)
      definition = ProcessorDefinition::MutateEach.new(options.merge(field: field))

      add_processor_definition(definition)

      self
    end

    def produce(field, **options)
      definition = ProcessorDefinition::Produce.new(options.merge(field: field))

      add_processor_definition(definition)

      self
    end

    def expose_field(field, **options)
      definition = ProcessorDefinition::ExposeField.new(options.merge(field: field))

      add_processor_definition(definition)

      self
    end

    def expose_fields(*fields, **options)
      definition = ProcessorDefinition::ExposeFields.new(options.merge(fields: fields))

      add_processor_definition(definition)

      self
    end

    def wrap_in_dto(field, **options)
      definition = ProcessorDefinition::WrapInDto.new(options.merge(field: field))

      add_processor_definition(definition)

      self
    end

    def extract_result(**options)
      definition = ProcessorDefinition::ExtractResult.new(options)

      add_processor_definition(definition)

      self
    end

    def validate(field, **options)
      definition = ProcessorDefinition::Validate.new(options.merge(field: field))

      add_processor_definition(definition)

      self
    end

    def add_processor_definition(processor_definition)
      processor_definitions << processor_definition
    end

  end
end
