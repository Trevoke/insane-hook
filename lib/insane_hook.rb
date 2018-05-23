require "insane_hook/version"

module InsaneHook

  class CommandNotRunError < StandardError ; end

  def self.included(mod)
    mod.class_variable_set(:@@_command, {required: [], optional: []})
    mod.extend(ClassMethods)
    mod.define_singleton_method(:need, mod.instance_method(:_need))
    mod.define_singleton_method(:allow, mod.instance_method(:_allow))
    mod.define_singleton_method(:call, mod.instance_method(:_call))
    #mod.define_method(:result, mod.instance_method(:_result))
  end

  def result(value=:_no_value)
    if value == :_no_value
      if instance_variable_defined?(:@_result)
        instance_variable_get(:@_result)
      else
        raise CommandNotRunError
      end
    else
      instance_variable_set(:@_result, value)
    end
  end

  def _need(key)
    fail "#{key} is not a symbol" unless key.is_a? Symbol
    args = self.class_variable_get(:@@_command)
    args[:required] << key
    self.class_variable_set(:@@_command, args)
  end

  def _allow(key)
    fail "#{key} is not a symbol" unless key.is_a? Symbol
    args = self.class_variable_get(:@@_command)
    args[:optional] << key
    self.class_variable_set(:@@_command, args)
  end

  def _call(&block)
    define_method(:call) do
      result(nil)
      instance_eval(&block)
      self
    end
  end

  module ClassMethods
    def new(**args, &block)
      obj = self.allocate
      self.class_variable_get(:@@_command)[:required].each do |var|
        value = args.fetch(var) { raise "#{var} not provided in #{self.class}" }
        obj.instance_variable_set("@#{var}", value)
        obj.class.class_eval{attr_reader var}
      end
      self.class_variable_get(:@@_command)[:optional].each do |var|
        value = args.fetch(var, nil)
        obj.instance_variable_set("@#{var}", value)
        obj.class.class_eval{attr_reader var}
      end
      obj.send :initialize
      obj
    end
  end
end
