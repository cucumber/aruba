# frozen_string_literal: true

ParameterType(name: 'channel', regexp: 'output|stderr|stdout', transformer: ->(name) { name })
ParameterType(name: 'command', regexp: '`([^`]*)`', transformer: ->(name) { name })
