Feature: `include_an_object` Matcher

  Use the `include_an_object` matcher to specify that a collection's objects include_an_object pass an expected matcher.
  This works on include_an_object enumerable object.

    ```ruby
    expect([1, 4, 5]).to include_an_object( be_odd )
    expect([1, 3, 'a']).to include_an_object( be_an(Integer) )
    expect([1, 3, 11]).to include_an_object( be < 10 )
    ```

  The matcher also supports compound matchers:

    ```ruby
    expect([1, 'a', 11]).to include_an_object( be_odd.and be < 10 )
    ```

  Background:
    Given I use a fixture named "cli-app"

  Scenario: Array usage
    Given a file named "spec/array_include_an_object_matcher_spec.rb" with:
      """ruby
      require 'spec_helper'

      RSpec.describe [1, 4, 'a', 11] do
        it { is_expected.to include_an_object( be_odd ) }
        it { is_expected.to include_an_object( be_an(Integer) ) }
        it { is_expected.to include_an_object( be < 10 ) }
        it { is_expected.not_to include_an_object( eq 'b' ) }
      end

      RSpec.describe [14, 'a'] do
        it { is_expected.to include_an_object( be_odd ) }
        it { is_expected.to include_an_object( be_an(Symbol) ) }
        it { is_expected.to include_an_object( be < 10 ) }
        it { is_expected.not_to include_an_object( eq 'a' ) }
      end
      """
    When I run `rspec`
    Then the output should contain all of these lines:
      | 8 examples, 4 failures                                      |
      | expected [14, "a"] to include an object be odd              |
      | expected [14, "a"] to include an object be a kind of Symbol |
      | expected [14, "a"] to include an object be < 10             |
      | expected [14, "a"] not to include an object eq "a"          |

  Scenario: Compound Matcher Usage
    Given a file named "spec/compound_include_an_object_matcher_spec.rb" with:
      """ruby
      require 'spec_helper'

      RSpec.describe [1, 'anything', 'something'] do
        it { is_expected.to include_an_object( be_a(String).and include("thing") ) }
        it { is_expected.to include_an_object( be_a(String).and end_with("g") ) }
        it { is_expected.to include_an_object( start_with("s").or include("y") ) }
        it { is_expected.not_to include_an_object( start_with("b").or include("b") ) }
      end

      RSpec.describe ['anything', 'something'] do
        it { is_expected.to include_an_object( be_a(Integer).and include("thing") ) }
        it { is_expected.to include_an_object( be_a(Integer).and end_with("z") ) }
        it { is_expected.to include_an_object( start_with("z").or include("1") ) }
        it { is_expected.not_to include_an_object( start_with("a").or include("some") ) }
      end
      """
    When I run `rspec`
    Then the output should contain all of these lines:
      | 8 examples, 4 failures                                                                           |
      | expected ["anything", "something"] to include an object be a kind of Integer and include "thing" |
      | expected ["anything", "something"] to include an object be a kind of Integer and end with "z"    |
      | expected ["anything", "something"] to include an object start with "z" or include "1"            |
