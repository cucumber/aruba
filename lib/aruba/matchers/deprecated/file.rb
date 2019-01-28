module RSpec
  module Matchers
    # rubocop:disable Style/PredicateName
    def have_same_file_content_like(expected)
      RSpec.deprecate('`have_same_file_content_like`', :replacement => '`have_same_file_content_as`')

      have_same_file_content_as(expected)
    end
    # rubocop:enable Style/PredicateName

    def a_file_with_same_content_like(expected)
      RSpec.deprecate('`a_file_with_same_content_like`', :replacement => '`a_file_with_same_content_as`')

      a_file_with_same_content_as(expected)
    end
  end
end
