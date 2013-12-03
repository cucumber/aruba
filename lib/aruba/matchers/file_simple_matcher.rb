module Aruba
  module Matchers
    class FileSimpleMatcher
      include RSpec::Expectations

      def self.check(path, expect_presence)
        if expect_presence
          expect( path ).to be_an_existing_file
        else
          expect( path ).not_to be_an_existing_file
        end
      end
    end
  end
end
