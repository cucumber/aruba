require 'spec_helper'

RSpec.describe Aruba::Processes::BasicProcess do
  let(:cmd) { 'foobar' }
  let(:exit_timeout) { 0 }
  let(:io_wait_timeout) { 0 }
  let(:working_directory) { Dir.pwd }
  let(:stdout) { "foo output" }
  let(:stderr) { "foo error output" }

  subject do
    Class.new(described_class) do
      def initialize(*args)
        @stdout = args.shift
        @stderr = args.shift
        super(*args)
      end

      def stdout(*_args)
        @stdout
      end

      def stderr(*_args)
        @stderr
      end
    end.new(stdout, stderr, cmd, exit_timeout, io_wait_timeout, working_directory)
  end

  describe "#inspect" do
    it "it shows useful info" do
      expected = /#<#<Class:0x[0-9A-Fa-f]+>:\d+ commandline="foobar": stdout="foo output" stderr="foo error output"/
      expect(subject.inspect).to match(expected)
    end

    context "with no stdout" do
      let(:stdout) { nil }

      it "it shows useful info" do
        expected = /#<#<Class:0x[0-9A-Fa-f]+>:\d+ commandline="foobar": stdout=nil stderr="foo error output"/
        expect(subject.inspect).to match(expected)
      end
    end

    context "with no stderr" do
      let(:stderr) { nil }

      it "it shows useful info" do
        expected = /#<#<Class:0x[0-9A-Fa-f]+>:\d+ commandline="foobar": stdout="foo output" stderr=nil/
        expect(subject.inspect).to match(expected)
      end
    end

    context "with neither stderr nor stdout" do
      let(:stderr) { nil }
      let(:stdout) { nil }

      it "it shows useful info" do
        expected = /#<#<Class:0x[0-9A-Fa-f]+>:\d+ commandline="foobar": stdout=nil stderr=nil/
        expect(subject.inspect).to match(expected)
      end
    end
  end
end
