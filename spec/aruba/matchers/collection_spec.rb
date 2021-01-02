require 'spec_helper'
require 'rspec/matchers/fail_matchers'

RSpec.describe 'Collection Matchers' do
  include RSpec::Matchers::FailMatchers

  describe '#include_an_object' do
    context 'when succeeding' do
      describe [1, 4, 'a', 11] do
        it { is_expected.to include_an_object(be_odd) }
        it { is_expected.to include_an_object(be_an(Integer)) }
        it { is_expected.to include_an_object(be < 10) }
        it { is_expected.not_to include_an_object(eq 'b') }
      end
    end

    context 'when failing' do
      it 'emits failure messages for all candidate objects' do
        no_oddity = [14, 'a']
        expect { expect(no_oddity).to include_an_object(be_odd) }
          .to fail_with <<~MESSAGE.strip
            expected [14, "a"] to include an object be odd

               object at index 0 failed to match:
                  expected `14.odd?` to be truthy, got false

               object at index 1 failed to match:
                  expected "a" to respond to `odd?`
          MESSAGE
      end

      it 'emits plain failure message when negated' do
        contains_evens = [14, 'a']
        expect { expect(contains_evens).not_to include_an_object(be_even) }
          .to fail_with 'expected [14, "a"] not to include an object be even'
      end

      it 'skips boiler plate if only one candidate object is given' do
        only_one = [14]
        expect { expect(only_one).to include_an_object(be_odd) }
          .to fail_with 'expected `14.odd?` to be truthy, got false'
      end
    end

    context 'when succeeding with compound matchers' do
      describe [1, 'anything', 'something'] do
        it { is_expected.to include_an_object(be_a(String).and(include('thing'))) }
        it { is_expected.to include_an_object(be_a(String).and(end_with('g'))) }
        it { is_expected.to include_an_object(start_with('q').or(include('y'))) }
        it { is_expected.not_to include_an_object(start_with('b').or(include('b'))) }
      end
    end
  end
end
