require "active_support"
require "active_support/core_ext"
require "active_model"
require "virtus"
require "hashie/mash"
require 'multi_json'

require "mini_camel/version"
require "mini_camel/dto"
require "mini_camel/strict_dto"
require "mini_camel/context"
require "mini_camel/exchange_error"
require "mini_camel/exchange_result"
require "mini_camel/exchange"
require "mini_camel/environment"
require "mini_camel/error"
require "mini_camel/default_error_handler"
require "mini_camel/route"
require "mini_camel/route_builder"
require "mini_camel/route_collection"
require "mini_camel/route_definition"
require "mini_camel/route_dispatcher"
require "mini_camel/route_finalizer"
require "mini_camel/route_generator"
require "mini_camel/interactor"

require 'mini_camel/processor/base'
require 'mini_camel/processor/each'
require 'mini_camel/processor/process'
require 'mini_camel/processor/process_each'
require 'mini_camel/processor/expose_field'
require 'mini_camel/processor/expose_fields'
require 'mini_camel/processor/extract_result'
require 'mini_camel/processor/pipeline'
require 'mini_camel/processor/to'
require 'mini_camel/processor/transform'
require 'mini_camel/processor/transform_each'
require 'mini_camel/processor/mutate'
require 'mini_camel/processor/mutate_each'
require 'mini_camel/processor/produce'
require 'mini_camel/processor/wrap_in_dto'
require 'mini_camel/processor/validate'

require 'mini_camel/processor_definition/base'
require 'mini_camel/processor_definition/each'
require 'mini_camel/processor_definition/process'
require 'mini_camel/processor_definition/process_each'
require 'mini_camel/processor_definition/expose_field'
require 'mini_camel/processor_definition/expose_fields'
require 'mini_camel/processor_definition/extract_result'
require 'mini_camel/processor_definition/pipeline'
require 'mini_camel/processor_definition/to'
require 'mini_camel/processor_definition/transform'
require 'mini_camel/processor_definition/transform_each'
require 'mini_camel/processor_definition/mutate'
require 'mini_camel/processor_definition/mutate_each'
require 'mini_camel/processor_definition/produce'
require 'mini_camel/processor_definition/wrap_in_dto'
require 'mini_camel/processor_definition/validate'

module MiniCamel

end
