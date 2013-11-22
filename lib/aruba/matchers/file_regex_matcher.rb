module Aruba
  module Matchers
    class FileRegexMatcher
      def initialize( expect_presence )
        @expect_presence = expect_presence
      end

      def check(regexes)
        found_files = Dir.glob('**/*')

        Array( regexes ).each do |r|
          result = found_files.grep( Regexp.new( r ) ).empty?

          if @expect_presence
            expect( result ).not_to be_true
          else
            expect( result ).to be_true
          end
        end
      end

    end
  end
end
