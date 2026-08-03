# frozen_string_literal: true

module Geoblacklight
  class CalnetLoginLinkComponent < ViewComponent::Base
    attr_reader :document

    def initialize(document:)
      @document = document
      super()
    end

    def render?
      document.restricted? && document.same_institution? && !helpers.document_available?
    end

    def original_url
      request&.original_url || helpers.root_path
    end
  end
end
