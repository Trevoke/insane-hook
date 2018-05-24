require "insane_hook/version"
require "insane_hook/errors"
require "insane_hook/class_methods"

module InsaneHook
  include InsaneHook::Errors
  include InsaneHook::Constants

  def self.included(mod)
    mod.class_variable_set(ARGS_VAR, {REQUIRED_ARGS => [], OPTIONAL_ARGS => []})
    mod.extend(ClassMethods)
    mod.define_singleton_method(:need, mod.instance_method(:_need))
    mod.define_singleton_method(:allow, mod.instance_method(:_allow))
    mod.define_singleton_method(:call, mod.instance_method(:_call))
  end

  def result(value=NO_ARG)
    if value == NO_ARG
      if instance_variable_defined?(RESULT_VAR)
        instance_variable_get(RESULT_VAR)
      else
        raise CommandNotRunError
      end
    else
      instance_variable_set(RESULT_VAR, value)
    end
  end

  def _need(key)
    fail "#{key} is not a symbol" unless key.is_a? Symbol
    args = self.class_variable_get(ARGS_VAR)
    args[REQUIRED_ARGS] << key
    self.class_variable_set(ARGS_VAR, args)
  end

  def _allow(key)
    fail "#{key} is not a symbol" unless key.is_a? Symbol
    args = self.class_variable_get(ARGS_VAR)
    args[OPTIONAL_ARGS] << key
    self.class_variable_set(ARGS_VAR, args)
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
end
