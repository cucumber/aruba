# @private
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
