module Aruba
  module Matchers
    class FileRegexMatcher
      include RSpec::Expectations

      def self.check(regex, expect_presence)
        if expect_presence
          expect( Dir.glob('**/*') ).to include_file_matching( regex )
        else
          expect( Dir.glob('**/*') ).not_to include_file_matching( regex )
        end
      end

    end
  end
end
