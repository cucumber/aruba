# frozen_string_literal: true

if RUBY_PLATFORM == "java"
  Before do
    @aruba_timeout_seconds = 15
  end
end
