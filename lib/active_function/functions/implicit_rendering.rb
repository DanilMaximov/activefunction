# frozen_string_literal: true

module ActiveFunction::Functions
  module ImplicitRendering
    def process(*)
      super

      default_render unless performed?
    end

    def performed? = @performed
    private def default_render = render
  end
end 