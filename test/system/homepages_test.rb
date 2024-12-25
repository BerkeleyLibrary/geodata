require 'application_system_test_case'

class HomepagesTest < ApplicationSystemTestCase
  test 'visiting the index' do
    visit '/'
    assert_text 'University of California, Berkeley'
  end
end
