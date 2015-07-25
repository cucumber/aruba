require 'spec_helper'

# create a value that does not exist in the collection. append a number to the original_str until not found
def nonexistant(coll = [], str = "zzz")
  not_found_value = str
  i = 1
  while coll.include?(not_found_value)
    not_found_value = "#{not_found_value}-#{i}"
    i += 1
  end
  not_found_value
end

describe WindowsEnvironmentVars do
  subject(:windows_env) { described_class.new }

  let(:env_1)         { "EnvVarAdapt-1" }
  let(:env_1_value)   { "EVA one one one" }
  let(:env_2)         { "EnvVarAdapt-2" }
  let(:env_2_value)   { "EVA two two two" }
  let(:default_value) { "default value" }

  it "doesn't have any lower-case letters" do
    expect(windows_env.to_h.select {|k, v| (k =~ /[a-z]+/) }).to be_empty
  end

  describe "only finds upper-case keys" do
    before(:each) do
      @orig_env = ENV.to_hash
      ENV.store(env_1, env_1_value)
      ENV.store(env_2, env_2_value)
    end
    after(:each) do
      ENV.clear
      ENV.update @orig_env
    end

    describe "fetch" do
      let(:key_doesnt_exist) { nonexistant(windows_env.to_h.keys) }

      it "finds key.upcase" do
        expect(windows_env.fetch(env_1.upcase, default_value)).to eq(env_1_value)
      end

      it "doesn't find key.downcase" do
        expect(windows_env.fetch(env_1.downcase, default_value)).to eq(default_value)
      end

      it "doesn't find key different mixed case" do
        expect(windows_env.fetch(env_2, default_value)).to eq(default_value)
      end

      it "doesn't find what it shouldn't find" do
        expect( windows_env.fetch(nonexistant(windows_env.to_h.keys), default_value) ).to eq(default_value)
      end

      it "#fetch(name, default)" do
        expect(windows_env.fetch(key_doesnt_exist, default_value)).to eq(ENV.fetch(key_doesnt_exist, default_value))
      end
    end

    describe "[]" do
      it "finds key.upcase" do
        expect(windows_env[env_1.upcase]).to eq(env_1_value)
      end

      it "doesn't find key.downcase" do
        expect(windows_env[env_1.downcase]).to be_falsey
      end

      it "doesn't find key different mixed case" do
        expect(windows_env[env_2]).to be_falsey
      end

      it "doesn't find what it shouldn't find" do
        expect( windows_env[nonexistant(windows_env.to_h.keys)] ).to be_falsey
      end
    end

    describe "key?" do
      it "finds key.upcase" do
        expect(windows_env.key?(env_1.upcase)).to be_truthy
      end

      it "doesn't find key.downcase" do
        expect(windows_env.key?(env_1.downcase)).to be_falsey
      end

      it "doesn't find key different mixed case" do
        expect(windows_env.key?(env_2)).to be_falsey
      end

      it "doesn't find what it shouldn't find" do
        expect( windows_env.key?(nonexistant(windows_env.to_h.keys)) ).to be_falsey
      end
    end
  end
end
