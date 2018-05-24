require "insane_hook/constants"

module ClassMethods
  include InsaneHook::Constants
  include InsaneHook::Errors
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
end
