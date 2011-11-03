require 'spec_helper'

describe Aruba::Api  do

  describe 'current_dir' do

    it "should return the current dir as 'tmp/aruba'" do
      current_dir.should match(/^tmp\/aruba$/)
    end
  end

end
