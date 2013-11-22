module Aruba
  module Matchers
    class FileSimpleMatcher
      def initialize( expect_presence )
        @expect_presence = expect_presence
      end

      def check(paths)
        Array( paths ).each do |p|
          if @expect_presence
            expect( File.exists? p ).to be_true
          else
            expect( File.exists? p ).not_to be_true
          end
        end
      end
    end
  end
end
