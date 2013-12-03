require 'spec_helper'

describe Aruba::Matchers::FileSimpleMatcher do
  context '#check' do
    it 'checks if file is present' do
      write_file( 'file' , 'hello world')

      in_current_dir do
        Aruba::Matchers::FileSimpleMatcher.check( 'file' , true )
      end
    end

    it 'checks if file is absent' do
      in_current_dir do
        Aruba::Matchers::FileSimpleMatcher.check( 'file' , false )
      end
    end
  end

end
