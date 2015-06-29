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
  def permissions(file)
    @actual = format("%o", File::Stat.new(file).mode)[-4,4].gsub(/^0*/, '')
  end

  match do |actual|
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
    format("expected that file \"%s\" would have permissions \"%s\", but has \"%s\".", @old_actual, @expected, @actual)
  end

  failure_message_when_negated do |actual|
    format("expected that file \"%s\" would not have permissions \"%s\", but has \"%s\".", @old_actual, @expected, @actual)
  end
end
