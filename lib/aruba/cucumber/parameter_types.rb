# frozen_string_literal: true

ParameterType(name: "channel", regexp: "output|stderr|stdout", transformer: ->(name) { name })
