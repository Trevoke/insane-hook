RSpec.describe InsaneHook do
  it "has a version number" do
    expect(InsaneHook::VERSION).not_to be nil
  end

  let(:klass_with_required) do
    Class.new(InsaneHook) do
      requires :required
      call do
        leak required
      end
    end
  end

  let(:klass_with_optional) do
    Class.new(InsaneHook) do
      optional :optional
      call do
        leak optional
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
end
