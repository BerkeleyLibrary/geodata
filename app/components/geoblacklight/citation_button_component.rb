# frozen_string_literal: true

module Geoblacklight
  class CitationButtonComponent < Blacklight::Document::ActionComponent
    def render_control
      button_tag label,
                 type: 'button',
                 id: @id,
                 class: %w[btn btn-primary],
                 data: { blacklight_modal: 'trigger', citation_url: url, turbo: false }
    end
  end
end
