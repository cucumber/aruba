require 'tempfile'

module ArubaWorld
  def in_current_dir(&block)
    create_dir(current_dir)
    Dir.chdir(current_dir, &block)
  end
  
  def current_dir
    'tmp/aruba'
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

  def create_file(file_name, file_content)
    in_current_dir do
      create_dir(File.dirname(file_name))
      File.open(file_name, 'w') { |f| f << file_content }
    end
  end

  def create_dir(dir_name)
    FileUtils.mkdir_p(dir_name) unless File.directory?(dir_name)
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

Then /^the exit status should be (\d+)$/ do |exit_status|
  @last_exit_status.should == exit_status.to_i
end

Then /^it should pass with:$/ do |partial_output|
  Then "the exit status should be 0"
  Then "I should see:", partial_output
end

Given /^a file named "([^\"]*)" with:$/ do |file_name, file_content|
  create_file(file_name, file_content)
end
