require 'tempfile'

module ArubaWorld
  def in_current_dir(&block)
    Dir.chdir(current_dir, &block)
  end
  
  def current_dir
    @current_dir ||= '.'
  end

  def run(command)
    stderr_file = Tempfile.new('cucumber')
    stderr_file.close
    in_current_dir do
      mode = Cucumber::RUBY_1_9 ? {:external_encoding=>"UTF-8"} : 'r'
      IO.popen("#{command} 2> #{stderr_file.path}", mode) do |io|
        @last_stdout = io.read
      end

      @last_exit_status = $?.exitstatus
    end
    @last_stderr = IO.read(stderr_file.path)
  end
end
World(ArubaWorld)

When /^I run (.*)$/ do |cmd|
  run(cmd)
end

Then /^I should see "([^\"]*)"$/ do |partial_output|
  @last_stdout.should =~ /#{partial_output}/
end

Then /^I should see:$/ do |partial_output|
  @last_stdout.should =~ /#{partial_output}/
end

Then /^I should see exactly "([^\"]*)"$/ do |exact_output|
  @last_stdout.should == eval(%{"#{exact_output}"})
end

Then /^I should see exactly:$/ do |exact_output|
  @last_stdout.should == exact_output
end
