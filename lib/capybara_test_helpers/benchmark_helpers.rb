# frozen_string_literal: true

require 'active_support/concern'
require 'active_support/core_ext/numeric/time'
require 'rainbow'

# rubocop:disable Style/ClassVars

# Public: Keeps track of the running time for user-defined helpers, useful as a
# way to keep track of the executed methods, and to easily spot slow operations.
module CapybaraTestHelpers::BenchmarkHelpers
  extend ActiveSupport::Concern

  included do
    @@indentation_level = 0
    @@indented_logs = []
  end

protected

  # Internal: Helper to benchmark an operation, outputs the method name, its
  # arguments, and the ellapsed time in milliseconds.
  def benchmark_method(method_name, args, kwargs)
    @@indented_logs.push(log = +'') # Push it in order, set the content later.
    @@indentation_level += 1
    before = Time.now
    yield
  ensure
    diff_in_millis = (Time.now - before).in_milliseconds.round
    @@indentation_level -= 1

    # Set the queued message with the method call and the ellapsed time.
    log.sub!('', _benchmark_str(method_name: method_name, args: args, kwargs: kwargs, time: diff_in_millis))

    # Print the messages once we outdent all, and clear the queue.
    @@indented_logs.each { |inner_log| Kernel.puts(inner_log) }.clear if @@indentation_level.zero?
  end

private

  # Internal: Indents nested method calls, and adds color to make it readable.
  def _benchmark_str(method_name:, args:, kwargs:, time:)
    args += [kwargs] unless kwargs.empty?
    args_str = args.map(&:inspect)
    [
      '  ' * @@indentation_level,
      Rainbow(self.class.name.chomp('TestHelper') + '#').slategray.rjust(40),
      Rainbow(method_name.to_s).cyan,
      Rainbow("(#{ args_str.join(', ') })").slategray,
      '  ',
      Rainbow("#{ time } ms").send(time > 1000 && :red || time > 100 && :yellow || :green),
    ].join('')
  end

  module ClassMethods
    # Hook: Benchmarks all methods in the class once it's loaded.
    def on_test_helper_load
      super
      benchmark_all
    end

    # Debug: Wraps all instance methods of the test helper class to log them.
    def benchmark_all
      return if defined?(@benchmarked_all)

      benchmark(instance_methods - superclass.instance_methods - [:lazy_for])
      @benchmarked_all = true
    end

    # Debug: Wraps a method to output its parameters and ellapsed time.
    #
    # Usage:
    #   benchmark :input_for
    #   benchmark def input_for(...)
    def benchmark(method_names)
      prepend(Module.new {
        Array.wrap(method_names).each do |method_name|
          define_method(method_name) { |*args, **kwargs, &block|
            benchmark_method(method_name, args, kwargs) { super(*args, **kwargs, &block) }
          }
        end
      })
      method_names
    end
  end
end
# rubocop:enable Style/ClassVars
