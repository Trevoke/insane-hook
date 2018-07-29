require "insane_hook/constants"
require "insane_hook/errors"

class InsaneHook
  module ClassMethods
    include Constants
    include Errors

    def new(**args)
      obj = self.allocate
      self.class_variable_get(ARGS_VAR)[REQUIRED_ARGS].each do |var|
        value = args.fetch(var) { raise(MissingArgumentError, "#{var} not provided in #{self.class}") }
        obj.instance_variable_set("@#{var}", value)
        obj.class.class_eval{attr_reader var}
      end
      self.class_variable_get(ARGS_VAR)[OPTIONAL_ARGS].each do |var|
        value = args.fetch(var, nil)
        obj.instance_variable_set("@#{var}", value)
        obj.class.class_eval{attr_reader var}
      end
      obj.send :initialize
      obj
    end

    def requires(key)
      fail "#{key} is not a symbol" unless key.is_a? Symbol
      args = self.class_variable_get(ARGS_VAR)
      args[REQUIRED_ARGS] << key
      self.class_variable_set(ARGS_VAR, args)
    end

    def optional(key)
      fail "#{key} is not a symbol" unless key.is_a? Symbol
      args = self.class_variable_get(ARGS_VAR)
      args[OPTIONAL_ARGS] << key
      self.class_variable_set(ARGS_VAR, args)
    end

    def call(**args, &block)
      if block_given?
        raise "Block cannot take arguments" if block.arity > 0
        raise "call method already defined" if self.instance_methods.include?(:call)
        define_method(:call) do
          instance_eval(&block)
          self
        end
      else
        new(**args).call
      end
    end
  end
end
