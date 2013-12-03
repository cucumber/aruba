require 'spec_helper'

describe Aruba::Matchers::FileRegexMatcher do
  context '#check' do
    it 'checks if file is present' do
      write_file( 'file123file' , 'hello world')

      in_current_dir do
        Aruba::Matchers::FileRegexMatcher.check( /\d{3}/, true )
      end
    end

    it 'checks if file is absent' do
      in_current_dir do
        Aruba::Matchers::FileRegexMatcher.check( /\d{6}/, false )
      end
    end
  end

end
