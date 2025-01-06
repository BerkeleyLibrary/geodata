RSpec.shared_examples 'download link visible' do |text, href, css_downloads|
  it "it has link #{text}" do
    expect(page).to have_link(text: text, href: href)
  end

  it 'is has download css attributes' do
    expect(page).to have_css(css_downloads[:location])
    expect(page).to have_css(css_downloads[:style])
    expect(page).to have_css(css_downloads[:type])
    expect(page).to have_css(css_downloads[:id])

  end
end

RSpec.shared_examples 'download link invisible' do |text|
  it "it has no link #{text}" do
    expect(page).not_to have_link(text: text)
  end

end

RSpec.shared_examples 'download link from Geoserver invisible' do |text, type, css_downloads|
  it "it has link #{text}" do
    expect(page).to have_link(text: text)
  end

  it 'is has download css attributes' do
    location = "a[data-download-path='/download/bb-s7038h?type=#{type}']"
    location = 'a[data-download-path="/download/bb-s7038h?type=shapefile"]'
    # location = 'a'
    type = "a[data-download-type=\"#{type}\"]"
    expect(page).to have_css(location)
    expect(page).to have_css(type)
    expect(page).to have_css(css_downloads[:style])
    expect(page).to have_css(css_downloads[:id])

  end

  # it "link '#{text}' visible" do
  #   css_downloads[:location] = "a[data-download-path=\"/download/bb-s7038h?type=#{type}\"]"
  #   css_downloads[:type] = "a[data-download-type=\"#{type}\"]"
  #   it_behaves_like 'download link visible', text, '', css_downloads
  # end

end
