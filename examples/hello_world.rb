#!/usr/bin/env ruby

$LOAD_PATH.push File.expand_path("../../lib", __FILE__)
require 'mini_camel'

# Define the interaction classes
class TransformHello < MiniCamel::Interactor

  attribute :input, String
  validates :input, presence: true

  def run
    {text: "#{input} World"}
  end

end

class TransformHappy < MiniCamel::Interactor

  attribute :input, String
  validates :input, presence: true

  def run
    {text: "The world is #{input}"}
  end

end

class WriteInput < MiniCamel::Interactor

  attribute :input, String
  validates :input, presence: true

  def run
    puts input
  end
end

# Define the routes
class HelloWorldRoutes < MiniCamel::RouteBuilder
  def configure
    from(:hello_world).
      desc("Transforms 'Hello' to 'Hello World'").
      to(:write_text).
      transform(:input, to: :output, with_class: TransformHello).
      extract_result(from: :output)

    from(:happy_world).
      desc("Transforms 'Happy' to 'The world is happy'").
      to(:write_text).
      transform(:input, to: :output, with_class: TransformHappy).
      extract_result(from: :output)

    # reusable route
    from(:write_text).
      desc("Writes some text to stdout").
      process(:input, with_class: WriteInput)
  end
end

class HelloWorldFacade
  include Singleton

  def hello_world
    environment.dispatch_route(:hello_world, with_data: {input: "Hello"})
  end

  def happy_world
    environment.dispatch_route(:happy_world, with_data: {input: "happy"})
  end

  private

  def environment
    @environment ||= build_environment
  end

  # Build and finalize the environment
  def build_environment
    env = MiniCamel::Environment.new
    env.register_route_builder(HelloWorldRoutes.new)
    env.finalize
  end

end

client = HelloWorldFacade.instance

# Dispatch the hello world route
exchange = client.hello_world

exchange.on(:success) do |result|
  puts result
end.on(:failure) do |error|
  puts error
end

# Dispatch the happy world route
exchange = client.happy_world

exchange.on(:success) do |result|
  puts result
end.on(:failure) do |error|
  puts error
end

