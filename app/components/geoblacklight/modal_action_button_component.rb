# frozen_string_literal: true

module Geoblacklight
  class ModalActionButtonComponent < Blacklight::Document::ActionComponent
    def render_control
      button_tag label,
                 type: 'button',
                 id: @id,
                 class: 'nav-link',
                 data: { blacklight_modal: 'trigger', modal_url: url, turbo: false }
    end
  end
end
