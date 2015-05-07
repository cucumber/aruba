# @!method have_permissions(permissions)
#   This matchers checks if <file> has <perm> permissions
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
#     end
#
#   @example Use matcher with string
#
#     RSpec.describe do
#       it { expect(file).to have_permissions('0700') }
#     end
RSpec::Matchers.define :have_permissions do |expected|
  expected_permissions = if expected.kind_of? Integer
                           expected.to_s(8)
                         else
                           expected.gsub(/^0*/, '')
                         end

  match do |actual|
    file_name = actual
    actual_permissions = sprintf( "%o", File::Stat.new(expand_path(file_name)).mode )[-4,4].gsub(/^0*/, '')

    actual_permissions == expected_permissions
  end

  failure_message do |actual|
    file_name = actual
    actual_permissions = sprintf( "%o", File::Stat.new(expand_path(file_name)).mode )[-4,4].gsub(/^0*/, '')

    format("expected that file \"%s\" would have permissions \"%s\", but has \"%s\".", file_name, expected_permissions, actual_permissions)
  end

  failure_message_when_negated do |actual|
    file_name = actual
    actual_permissions = sprintf( "%o", File::Stat.new(expand_path(file_name)).mode )[-4,4].gsub(/^0*/, '')

    format("expected that file \"%s\" would not have permissions \"%s\", but has \"%s\".", file_name, expected_permissions, actual_permissions)
  end
end
