# MiniCamel

MiniCamel allows you to perform simple data transformations and combine these transformations to reusable business processes. It is inspired by his big brother [Apache Camel](http://camel.apache.org/index.html "Apache Camel").

## Basic Usage

The idea behind MiniCamel is to define a route (or multiple) to transform an input presentation to an output presentation.

```ruby
# Checkout the 'examples' folder for the full example
class HelloWorldRoutes < MiniCamel::RouteBuilder
  def configure
    from(:hello_world).
      desc("Transforms 'Hello' to 'Hello World'").
      to(:write_text).
      transform(:input, to: :output, with_class: TransformHello).
      extract_result(from: :output)

    # reusable route
    from(:write_text).
      desc("Writes some text to stdout").
      process(:input, with_class: WriteInput)
  end
end
```

In each route you can define custom interactor classes that will transform or process specific parameters.

```ruby
# transform(:input, to: :output, with_class: TransformHello)

class TransformHello < MiniCamel::Interactor

  attribute :input, String
  validates :input, presence: true

  def run
    {text: "#{input} World"}
  end

end
```

This interactor will process the input string and transform it to a `Hash`. The return value of the interactor will be written into `output`.

After you have defined all your routes you can generate your MiniCamel environment.

```ruby
environment = MiniCamel::Environment.new
environment.register_route_builder(HelloWorldRoutes.new)
environment.finalize
```

And dispatch one of the routes.

```ruby
exchange = environment.dispatch_route(:hello_world, with_data: {input: "Hello"})
```

The result of the `dispatch_route` call will be a `MiniCamel::Exchange`. An exchange is an object that is transfered between each processor of a route. It exposes two callbacks

```ruby
exchange.on(:success) do |result|
  puts result
end.on(:failure) do |error|
  puts error
end
```

The `on(:success)` callback will yield the exchange result if the exchange was processed successfully otherwise it will yield an error in the `on(:failure)` callback.

## The internals

### Context

The context is a part of the exchange and holds the data of the exchange.

### Processors

Each route can call a number of processors. A processor is a simple logical unit that changes the context or uses its data to trigger specific business processes.

#### ExposeField

The `ExposeField` processor exposes a field from an object or a hash to the context so the value can be used by other processors.

```ruby
# context: {test: {hello: "world"}}
expose_field(:hello, from: :test)
# new context: {test: {hello: "world"}, hello: "world"}
```

Further more you can change the name of the exposed field.

```ruby
# context: {test: {hello: "world"}}
expose_field(:hello, from: :test, as: :bye)
# new context: {bye: "world", test: {hello: "world"}}
```

#### ExposeFields

The `ExposeFields` processor works like _ExposeField_ but it allows to expose multiple fields at once. Unlike ExposeField it does not allow to change the name of the exposed fields.

```ruby
# context: {test: {hello: "world", foo: "bar"}}
expose_fields(:hello, :foo, from: :test)
# new context: {hello: "world", foo: "bar", test: {hello: "world"}}
```

#### ExtractResult

The `ExtractResult` processor extracts an object from the context. This object will be used as the result of the exchange. Please be aware that the result object has to be of the type `Hash` or `MiniCamel::Dto`.

```ruby
from(:extract_result_example).
  desc("Extracts a result from ':test'.").
  extract_result(from: :test)

exchange = env.dispatch_route(:extract_result_example, with_data: {test: {hello: "world"})
exchange.on(:success) do |result|
  puts result # -> {hello: "world"}
end
```

#### Mutate

The `Mutate` processor transforms a value with an interactor and writes the return value back to the original field. If you want to transform multiple values than you should use the `TransformProcessor`.

```ruby
# context: {test: {hello: "world"}}
mutate(:test, with_class: MutateTestInteractor)
# new context: {test: {foo: "bar"}} (the MutateTestInteractor class returns {foo: "bar"})
```

#### MutateEach

Like the `Mutate` processor the `MutateEach` processor transforms a value with an interactor. But instead of a single value it transforms the array under the given field name. You may also provide `additional_fields` for each step.

```ruby
# context: {values: [1, 2, 3]}
mutate_each(:value, in: :values, with_class: MultiplyBy2Interactor)
# new context: {values: [2, 4, 6]}
```

#### To

`To` allows you to route the current exchange to a sub route and to reuse predifined processes.

```ruby
from(:hello_world).
  desc("Prints 'Hello'").
  to(:print_text)

from(:foo_bar).
  desc("Prints 'Foo'").
  to(:print_text)

from(:print_text).
  desc("Prints some text to stdout").
  process(:input, with_class: WriteInput)

env.dispatch_route(:hello_world, with_data: {input: 'Hello'})
# -> "Hello"

env.dispatch_route(:foo_bar, with_data: {input: 'Foo'})
# -> "Foo"
```

#### Pipeline

`Pipeline` allows you to call multiple sub routes in one call.

```ruby
from(:ask_question).
  desc("Prints some user input").
  pipeline(:ask_for_input, :print_text)

from(:print_text).
  desc("Prints some text to stdout").
  process(:input, with_class: WriteInput)

from(:ask_for_input).
  desc("Asks the user for input").
  produce(:input, with_class: AskUserForInputInteractor)

env.dispatch_route(:ask_question, with_data: {})
# -> depends on user input
```

#### Process

`Process` allows you to execute some business logic. `Process` does not modify the data you pass into it.

```ruby
from(:print_text).
  desc("Prints some text to stdout").
  process(:input, with_class: WriteInput)

env.dispatch_route(:print_text, with_data: {input: "foobar"})
# -> "foobar"
```

#### ProcessEach

`ProcessEach` allows you to process each value in an array. Just like `Process` it does not modify the array values you pass into it. You may also provide `additional_fields` for each step.

```ruby
from(:greet).
  desc("Prints each value of an array").
  process(:input, in: :inputs, with_class: WriteInput)

env.dispatch_route(:greet, with_data: {inputs: ["hello", "world"]})
# -> "hello"
# -> "world"
```

#### Transform

The `Transform` processor allows you to transform multiple values into one result value with an interactor.

```ruby
from(:concat_foobar).
  desc("Concats foo bar to foobar").
  transform(:foo, :bar, to: :foobar, with_class: ConcatFoobarInteractor).
  process(:foobar, with_class: PrintInput)

env.dispatch_route(:concat_foobar, with_data: {foo: "foo", bar: "bar"})
# -> "foobar"
```

#### TransformEach

The `TransformEach` processor allows you to transform array values and put them into a new array with an interactor. You may also provide `additional_fields` for each step.

```ruby
from(:multiply_by_two).
  desc("Multiplies each array entry by two and puts it into a new numbers_multiplied_by_two array.").
  transform(:number, in: :numbers, to: :numbers_multiplied_by_two, with_class: MultiplyByTwoInteractor).
  process(:numbers_multiplied_by_two, with_class: PrintInput)

env.dispatch_route(:multiply_by_two, with_data: {numbers: [1,2,3]})
# -> [2,4,6]
```

#### Validate

The `Validate` processor will validate a field you pass into it. The value of the field has to respond to `invalid?`.

```ruby
class InvalidValue

  def invalid?
    true
  end

end

class InvalidValueError < StandardError; end

from(:check_value).
  desc("Raises a InvalidValueError").
  validate(:value, raise_error: InvalidValueError)

env.dispatch_route(:check_value, with_data: {value: InvalidValue.new})
# -> raises InvalidValueError
```

## TODO

* Improve README
* Check for unknown routes at route finalization
* Create a plugin system to easily add new processors
* Improve exception handling


## License

Copyright (c) 2016 Spas Poptchev

MIT License

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

