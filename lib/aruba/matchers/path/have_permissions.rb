require 'rspec/expectations/version'

# @!method have_permissions(permissions)
#   This matchers checks if <file> or <directory> has <perm> permissions
#
#   @param [Fixnum, String] permissions
#     The permissions as octal number, e.g. `0700`, or String, e.g. `'0700'`
#
#   @return [TrueClass, FalseClass] The result
#
#     false:
#     * if file has permissions
#     true:
#     * if file does not have permissions
#
#   @example Use matcher with octal number
#
#     RSpec.describe do
#       it { expect(file).to have_permissions(0700) }
#       it { expect(directory).to have_permissions(0700) }
#     end
#
#   @example Use matcher with string
#
#     RSpec.describe do
#       it { expect(file).to have_permissions('0700') }
#       it { expect(files).to include a_path_with_permissions('0700') }
#       it { expect(directory).to have_permissions('0700') }
#       it { expect(directories).to include a_path_with_permissions('0700') }
#     end
RSpec::Matchers.define :have_permissions do |expected|
  def permissions(file)
    @actual = Aruba.platform.filesystem_status.new(file).mode
  end

  match do |actual|
    stop_all_commands

    @old_actual = actual
    @actual = permissions(expand_path(@old_actual))

    @expected = if expected.is_a? Integer
                  expected.to_s(8)
                elsif expected.is_a? String
                  expected.gsub(/^0*/, '')
                else
                  expected
                end

    values_match? @expected, @actual
  end

  failure_message do |actual|
    format("expected that path \"%s\" has permissions \"%s\", but has \"%s\".", @old_actual, @expected, @actual)
  end

  failure_message_when_negated do |actual|
    format("expected that path \"%s\" does not have permissions \"%s\", but has \"%s\".", @old_actual, @expected, @actual)
  end
end

if RSpec::Expectations::Version::STRING >= '3.0'
  RSpec::Matchers.alias_matcher :a_path_having_permissions, :have_permissions
end
