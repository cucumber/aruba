require 'rspec/core'
require 'aruba/api'

module ManipulatesConstants
  # http://digitaldumptruck.jotabout.com/?p=551
  def with_constants(constants, &block)
    saved_constants = {}
    constants.each do |constant, val|
      saved_constants[ constant ] = Object.const_get( constant )
      Kernel::silence_warnings { Object.const_set( constant, val ) }
    end

    begin
      block.call
    ensure
      constants.each do |constant, val|
        Kernel::silence_warnings { Object.const_set( constant, saved_constants[ constant ] ) }
      end
    end
  end
end

# http://mislav.uniqpath.com/2011/06/ruby-verbose-mode/
# these methods are already present in Active Support
module Kernel
  def silence_warnings
    with_warnings(nil) { yield }
  end

  def with_warnings(flag)
    old_verbose, $VERBOSE = $VERBOSE, flag
    yield
  ensure
    $VERBOSE = old_verbose
  end
end unless Kernel.respond_to? :silence_warnings

RSpec.configure do |config|
  config.filter_run :focus => true
  config.run_all_when_everything_filtered = true
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.include(ManipulatesConstants)
end
