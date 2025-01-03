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
