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
      self.class_variable_get(ARGS_VAR)[OPTIONAL_ARGS].each do |var, val|
        value = args.fetch(var, val)
        obj.instance_variable_set("@#{var}", value)
        obj.class.class_eval{attr_reader var}
      end
      obj.send :initialize
      obj
    end

    def required(*keys)
      fail "#{key} is not a symbol" unless keys.all? { |x| x.is_a? Symbol }
      args = self.class_variable_get(ARGS_VAR)
      args[REQUIRED_ARGS] = (args[REQUIRED_ARGS] + keys).uniq
      self.class_variable_set(ARGS_VAR, args)
    end

    def optional(*no_values, **with_values)
      keys = no_values + with_values.keys
      fail "#{key} is not a symbol" unless keys.all? { |x| x.is_a? Symbol }
      args = self.class_variable_get(ARGS_VAR)
      no_values.each do |optional_arg|
        args[OPTIONAL_ARGS][optional_arg] ||= nil
      end
      with_values.each do |optional_arg, default_value|
        args[OPTIONAL_ARGS][optional_arg] ||= default_value
      end
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
