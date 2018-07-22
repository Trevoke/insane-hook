RSpec.describe InsaneHook do
  it "has a version number" do
    expect(InsaneHook::VERSION).not_to be nil
  end

  let(:klass) do
    klass = Class.new(InsaneHook) do
      requires :required
      fallbacks :optional
      call do
        result required
      end
    end
  end

  it "has a pretty API" do
    instance = klass.new(required: 3)
    expect { instance.result }.to raise_error InsaneHook::CommandNotRunError

    actual = instance.call
    expect(actual).to eq(instance)
    expect(actual.result).to eq(3)
  end

  it "has a class-level call method" do
    actual = klass.call(required: 3)
    expect(actual.result).to eq(3)
  end

  it "blows up if a required argument is not passed in" do
    expect { klass.new }.to raise_error InsaneHook::MissingArgumentError
  end
end
