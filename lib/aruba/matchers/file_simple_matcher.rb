module Aruba
  module Matchers
    class FileSimpleMatcher
      include RSpec::Expectations

      def initialize( expect_presence )
        @expect_presence = expect_presence
      end

      def check(paths)
        Array( paths ).each do |p|
          if @expect_presence
            expect( p ).to be_an_existing_file
          else
            expect( p ).not_to be_an_existing_file
          end
        end
      end
    end
  end
end
