module Aruba
  module Matchers
    class FileRegexMatcher
      include RSpec::Expectations

      def initialize( expect_presence )
        @expect_presence = expect_presence
      end

      def check(regexes)
        Array( regexes ).each do |r|
          if @expect_presence
            expect( Dir.glob('**/*') ).to include_file_matching( r )
          else
            expect( Dir.glob('**/*') ).not_to include_file_matching( r )
          end
        end
      end

    end
  end
end
