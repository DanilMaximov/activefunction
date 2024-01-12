# frozen_string_literal: true

require "bundler/setup"
require "ruby-next/language/runtime" unless ENV["CI"]

require "minitest/autorun"
require "minitest/reporters"

require "active_function"

Minitest::Reporters.use! [Minitest::Reporters::SpecReporter.new(color: true)]
