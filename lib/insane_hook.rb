require "insane_hook/version"

module InsaneHook
  ARGS_VAR = :@@_command
  REQUIRED_ARGS = :required
  OPTIONAL_ARGS = :optional
  RESULT_VAR = :@_result
  NO_ARG = :_no_value
  class CommandNotRunError < StandardError ; end
  class MissingArgumentError < StandardError ; end

  def self.included(mod)
    mod.class_variable_set(::InsaneHook::ARGS_VAR, {REQUIRED_ARGS => [], OPTIONAL_ARGS => []})
    mod.extend(ClassMethods)
    mod.define_singleton_method(:need, mod.instance_method(:_need))
    mod.define_singleton_method(:allow, mod.instance_method(:_allow))
    mod.define_singleton_method(:call, mod.instance_method(:_call))
  end

  def result(value=NO_ARG)
    if value == NO_ARG
      if instance_variable_defined?(::InsaneHook::RESULT_VAR)
        instance_variable_get(::InsaneHook::RESULT_VAR)
      else
        raise CommandNotRunError
      end
    else
      instance_variable_set(::InsaneHook::RESULT_VAR, value)
    end
  end

  def _need(key)
    fail "#{key} is not a symbol" unless key.is_a? Symbol
    args = self.class_variable_get(::InsaneHook::ARGS_VAR)
    args[REQUIRED_ARGS] << key
    self.class_variable_set(::InsaneHook::ARGS_VAR, args)
  end

  def _allow(key)
    fail "#{key} is not a symbol" unless key.is_a? Symbol
    args = self.class_variable_get(::InsaneHook::ARGS_VAR)
    args[OPTIONAL_ARGS] << key
    self.class_variable_set(::InsaneHook::ARGS_VAR, args)
  end

  def _call(**args, &block)
    if block_given?
      raise "Block cannot take arguments" if block.arity > 0
      raise "call method already defined" if self.instance_methods.include?(:call)
      define_method(:call) do
        result(nil)
        instance_eval(&block)
        self
      end
    else
      new(**args).call
    end

  end

  module ClassMethods
    def new(**args)
      obj = self.allocate
      self.class_variable_get(::InsaneHook::ARGS_VAR)[REQUIRED_ARGS].each do |var|
        value = args.fetch(var) { raise(::InsaneHook::MissingArgumentError, "#{var} not provided in #{self.class}") }
        obj.instance_variable_set("@#{var}", value)
        obj.class.class_eval{attr_reader var}
      end
      self.class_variable_get(::InsaneHook::ARGS_VAR)[OPTIONAL_ARGS].each do |var|
        value = args.fetch(var, nil)
        obj.instance_variable_set("@#{var}", value)
        obj.class.class_eval{attr_reader var}
      end
      obj.send :initialize
      obj
    end
  end
end
