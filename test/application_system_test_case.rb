require 'test_helper'

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  # driven_by :selenium, using: :chrome, screen_size: [1400, 1400]
  driven_by :selenium, using: :chrome, screen_size: [1400, 1400], options: {
    browser: :remote,
    url: 'http://selenium.test:4444'
  }

end
