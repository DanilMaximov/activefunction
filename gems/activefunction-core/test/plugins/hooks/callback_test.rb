# frozen_string_literal: true

require "test_helper"
require "active_function_core/plugins/hooks"

describe ActiveFunctionCore::Plugins::Hooks::Hook::Callback do
  let(:klass) do
    Class.new do
      def self.callback_options
        {
          if: ->(v, context:) { context.send(v) if context.respond_to?(v, true) }
        }
      end

      def target_method
      end

      def executable?
        true
      end
    end
  end

  subject { ActiveFunctionCore::Plugins::Hooks::Hook::Callback.new(options, target) }

  let(:target) { :target_method }
  let(:options) { {} }
  let(:context) { klass.new }

  describe "#run" do
    it "should execute target method" do
      context.expects(target).once

      subject.run(context)
    end

    it "should execute target method with options" do
      options[:if] = :executable?

      context.expects(:executable?).once

      subject.run(context)
    end

    it "should not execute target method when some of option != true" do
      options[:if] = :undefined_method # returns nil

      context.expects(target).never

      subject.run(context)
    end

    it "should raise ArgumentError when target method is not defined" do
      assert_raises(ArgumentError) do
        subject.with(target: :undefined_method).run(context)
      end
    end

    it "should raise ArgumentError when :callback_options is not defined in context" do
      assert_raises(ArgumentError) do
        subject.run(Object.new)
      end
    end
  end

  describe "#normalized_options" do
    it "should wrap options with proc" do
      options[:if] = :executable?

      _(subject.send(:normalized_options, options, context).first.call).must_equal true
    end
  end
end
