require "insane_hook/class_methods"
require "insane_hook/version"
require "insane_hook/errors"

class InsaneHook
  include InsaneHook::Errors
  include InsaneHook::Constants

  def self.inherited(subclass)
    subclass.class_variable_set(ARGS_VAR, {REQUIRED_ARGS => [], OPTIONAL_ARGS => []})
    subclass.extend(InsaneHook::ClassMethods)
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
end
