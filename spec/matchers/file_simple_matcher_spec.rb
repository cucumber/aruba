require 'spec_helper'

describe Aruba::Matchers::FileSimpleMatcher do
  context '#check' do
    it 'checks if file is present' do
      write_file( 'file' , 'hello world')

      in_current_dir do
        Aruba::Matchers::FileSimpleMatcher.new( true ).check( 'file' )
      end
    end

    it 'checks if file is present' do
      write_file( 'file' , 'hello world')

      in_current_dir do
        Aruba::Matchers::FileSimpleMatcher.new( true ).check( 'file' )
      end
    end
  end

end
