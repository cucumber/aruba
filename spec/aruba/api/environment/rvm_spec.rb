require 'spec_helper'

RSpec.describe Aruba::Api::Rvm do
  include_context 'uses aruba API'

  around do |example|
    Aruba.platform.with_environment do
      example.run
    end
  end

  let(:instance) { @aruba }

  subject { instance }

  describe '.use_clean_gemset' do
    before do
      allow(instance).to receive(:set_environment_variable).with(instance, anything)
    end

    context "when creating gemset was unsuccessful" do
      before do
        allow(instance).to receive(:current_gemset_home).with("foobar").and_raise("I didn't understand rvm's output: blah blah blah")
      end

      it "fails" do
        expected = "I didn't understand rvm's output: blah blah blah"
        expect{ subject.use_clean_gemset("foobar") }.to raise_error(expected)
      end
    end

    context "when creating gemset succeeded" do
      let(:gem_path) { "/home/foo/ruby-1.2.3:/home/foo/ruby-1.2.3@global" }

      let(:path) do
        [
          "/home/foo/ruby-1.2.3/bin",
          "/home/foo/ruby-1.2.3@global/bin",
          "/bar",
          "/baz"
        ].join(":")
      end

      before do
        allow(instance).to receive(:current_gemset_home).and_return("/home/foo/ruby-1.2.3@foobar")
        allow(instance).to receive(:current_gem_home).and_return("/home/foo/ruby-1.2.3")
        allow(ENV).to receive(:[]).with('GEM_PATH').and_return(gem_path)
        allow(ENV).to receive(:[]).with('PATH').and_return(path)

        # stubs for have_received to work
        allow(instance).to receive(:set_environment_variable).with('GEM_HOME', anything)
        allow(instance).to receive(:set_environment_variable).with('GEM_PATH', anything)
        allow(instance).to receive(:set_environment_variable).with('BUNDLE_PATH', anything)
        allow(instance).to receive(:set_environment_variable).with('PATH', anything)

        allow(instance).to receive(:rvm_run)
        allow(instance).to receive(:delete_environment_variable)
      end

      it "installs bundler" do
        expect(instance).to receive(:rvm_run).with("gem install bundler", :timeout => 30)
        subject.use_clean_gemset("foobar")
      end

      it "sets GEM_HOME" do
        expect(instance).to receive(:rvm_run).with("gem install bundler", anything) do
          expect(instance).to have_received(:set_environment_variable).with('GEM_HOME', '/home/foo/ruby-1.2.3@foobar')
        end
        subject.use_clean_gemset("foobar")
      end

      it "sets BUNDLE_PATH" do
        expect(instance).to receive(:rvm_run).with("gem install bundler", anything) do
          expect(instance).to have_received(:set_environment_variable).with('BUNDLE_PATH', '/home/foo/ruby-1.2.3@foobar')
        end
        subject.use_clean_gemset("foobar")
      end

      it "resets BUNDLE_BIN_PATH" do
        expect(instance).to receive(:rvm_run).with("gem install bundler", anything) do
          expect(instance).to have_received(:delete_environment_variable).with('BUNDLE_BIN_PATH')
        end
        subject.use_clean_gemset("foobar")
      end

      it "resets BUNDLE_GEMFILE" do
        expect(instance).to receive(:rvm_run).with("gem install bundler", anything) do
          expect(instance).to have_received(:delete_environment_variable).with('BUNDLE_GEMFILE')
        end
        subject.use_clean_gemset("foobar")
      end

      it "resets RUBYOPT" do
        expect(instance).to receive(:rvm_run).with("gem install bundler", anything) do
          expect(instance).to have_received(:delete_environment_variable).with('RUBYOPT')
        end
        subject.use_clean_gemset("foobar")
      end

      context "with an existing GEM_PATH" do
        context "with one entry" do
          # Never versions of RVM need the '@global' gemset to work,
          # so this case may no longer be relevant
          let(:gem_path) { "/home/foo/ruby-1.2.3" }
          it "replaces GEM_PATH" do
            expect(instance).to receive(:rvm_run).with("gem install bundler", anything) do
              expect(instance).to have_received(:set_environment_variable).with('GEM_PATH', '/home/foo/ruby-1.2.3@foobar')
            end
            subject.use_clean_gemset("foobar")
          end
        end

        context "with multiple entries" do
          let(:gem_path) { "/home/foo/ruby-1.2.3:/home/foo/ruby-1.2.3@global" }

          it "replaces current gemset in GEM_PATH" do
            expect(instance).to receive(:rvm_run).with("gem install bundler", anything) do
              expected_paths = [
                '/home/foo/ruby-1.2.3@foobar',
                '/home/foo/ruby-1.2.3@global'
              ].join(File::PATH_SEPARATOR)

              expect(instance).to have_received(:set_environment_variable).with('GEM_PATH', expected_paths)
            end
            subject.use_clean_gemset("foobar")
          end
        end
      end

      context "with an empty GEM_PATH" do
        let(:gem_path) { nil }
        it "sets GEM_PATH to new gemset path" do
          expect(instance).to receive(:rvm_run).with("gem install bundler", anything) do
            expected_path = '/home/foo/ruby-1.2.3@foobar'
            expect(instance).to have_received(:set_environment_variable).with('GEM_PATH', expected_path)
          end
          subject.use_clean_gemset("foobar")
        end
      end

      context "with an existing PATH" do
        context "with multiple entries" do
          let(:path) do
            [
              "/home/foo/ruby-1.2.3/bin",
              "/home/foo/ruby-1.2.3@global/bin",
              "/bar",
              "/baz"
            ].join(File::PATH_SEPARATOR)
          end

          it "inserts gemset into beginning of PATH" do
            expect(instance).to receive(:rvm_run).with("gem install bundler", anything) do
              expected_path = [
                '/home/foo/ruby-1.2.3@foobar/bin',
                '/home/foo/ruby-1.2.3@global/bin',
                '/bar',
                '/baz'
              ].join(File::PATH_SEPARATOR)
              expect(instance).to have_received(:set_environment_variable).with('PATH', expected_path)
            end

            subject.use_clean_gemset("foobar")
          end
        end
      end

      context "with no PATH" do
        let(:path) { nil }
        it "sets PATH to new gemset bin dir" do
          expect(instance).to receive(:rvm_run).with("gem install bundler", anything) do
            expected_path = '/home/foo/ruby-1.2.3@foobar/bin'
            expect(instance).to have_received(:set_environment_variable).with('PATH', expected_path)
          end
          subject.use_clean_gemset("foobar")
        end
      end
    end
  end

  context "with an given process" do
    let(:process) { instance_double(Aruba::Processes::BasicProcess) }

    before do
      allow(instance).to receive(:last_command_started).and_return(process)
      allow(process).to receive(:stdout).and_return("some output\n")
      allow(instance).to receive(:run_simple)
    end

    describe '#rvm_capture' do
      it "runs the given command" do
        expect(instance).to receive(:run_simple).with("foobar", true)
        subject.send(:rvm_capture, "foobar")
      end

      it "returns the standard output" do
        allow(process).to receive(:stdout).and_return("foo bar baz\n")
        expect(subject.send(:rvm_capture, "foobar")).to eq("foo bar baz\n")
      end
    end

    describe '#run' do
      context "without options" do
        it "runs the command" do
          expect(instance).to receive(:run_simple).with("foobar", true)
          subject.send(:rvm_run, "foobar")
        end
      end

      context "with timeout option" do
        it "runs the command with given timeout" do
          expect(instance).to receive(:run_simple).with("foobar", true, 13)
          subject.send(:rvm_run, "foobar", :timeout => 13)
        end
      end
    end
  end

  describe '#current_gemset_home' do
    context "with an unrecognized version of RVM" do
      before do
        cmd = "rvm gemset create \"foobar\""
        allow(instance).to receive(:rvm_capture).with(cmd).and_return("blah blah\n")
      end

      it "fails" do
        expected = "I didn't understand rvm's output: blah blah"
        expect{ subject.send(:current_gemset_home, "foobar") }.to raise_error(expected)
      end
    end

    context "when gemset was created successfully" do
      before do
        cmd = 'rvm gemset create "foobar"'
        output = "ruby-2.2.1 - #gemset created /home/foo/ruby-1.2.3@foobar\n"
        allow(instance).to receive(:rvm_capture).with(cmd).and_return(output)
      end

      it "returns the full gemset path" do
        expect(subject.send(:current_gemset_home, "foobar")).to eq("/home/foo/ruby-1.2.3@foobar")
      end
    end

    context "with an outdated version of RVM" do
      context "when gemset was created successfully" do
        before do
          cmd = 'rvm gemset create "foobar"'
          output = "'foobar' gemset created (/home/foo/ruby-1.2.3@foobar).\n"
          allow(instance).to receive(:rvm_capture).with(cmd).and_return(output)
        end

        it "returns the full gemset path" do
          expect(subject.send(:current_gemset_home, "foobar")).to eq("/home/foo/ruby-1.2.3@foobar")
        end
      end
    end
  end
end
