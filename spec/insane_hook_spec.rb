RSpec.describe InsaneHook do
  it "has a version number" do
    expect(InsaneHook::VERSION).not_to be nil
  end

  let(:klass_with_required) do
    Class.new(InsaneHook) do
      required :required
      call do
        leak required
      end
    end
  end

  let(:klass_with_optional) do
    Class.new(InsaneHook) do
      optional optional: 5
      call do
        leak optional
      end
    end
  end

  let(:klass_with_many_required) do
    Class.new(InsaneHook) do
      required :arg1, :arg2
      call do
        leak arg1 + arg2
      end
    end
  end

  let(:klass_with_both_types_of_optional) do
    Class.new(InsaneHook) do
      optional :opt1, opt2: 5
      call do
        leak({ opt1: opt1, opt2: opt2 })
      end
    end
  end

  let(:klass_with_conflicting_optionals) do
    Class.new(InsaneHook) do
      optional opt1: 5
      optional :opt1
      call do
        leak opt1
      end
    end
  end

  let(:klass_with_conflicting_optional_values) do
    Class.new(InsaneHook) do
      optional opt1: 10
      optional opt1: 3
      call do
        leak opt1
      end
    end
  end

  it "has a pretty API" do
    instance = klass_with_required.new(required: 3)
    expect { instance.result }.to raise_error InsaneHook::CommandNotRunError

    actual = instance.call
    expect(actual).to eq(instance)
    expect(actual.result).to eq(3)
  end

  it "has a class-level call method" do
    actual = klass_with_required.call(required: 3)
    expect(actual.result).to eq(3)
  end

  it "blows up if a required argument is not passed in" do
    expect { klass_with_required.new }.to raise_error InsaneHook::MissingArgumentError
  end

  it "allows the optional argument to make a difference" do
    actual = klass_with_optional.call(optional: 3)
    expect(actual.result).to eq(3)
  end

  it "lets the programmer set a default value for the optional parameter" do
    actual = klass_with_optional.call
    expect(actual.result).to eq(5)
  end

  it "handles many required arguments well" do
    actual = klass_with_many_required.call(arg1: 1, arg2: 2)
    expect(actual.result).to eq(3)
  end

  it "handles optional arguments both with and without values" do
    actual = klass_with_both_types_of_optional.call
    expect(actual.result).to eq({opt1: nil, opt2: 5})
  end

  it "prefers optional arguments with values to optional arguments without values" do
    actual = klass_with_conflicting_optionals.call
    expect(actual.result).to eq(5)
  end

  it "prefers the first given value for an optional argument" do
    actual = klass_with_conflicting_optional_values.call
    expect(actual.result).to eq(10)
  end
end
