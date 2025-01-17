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

RSpec.shared_examples 'export geofile to local' do |file_name, link_name|
  let(:download_dir) { '/opt/app/tmp/cache/downloads' }
  let(:export_file_path) { File.join(download_dir, file_name) }

  after(:each) do
    FileUtils.rm_f(export_file_path)
    Capybara.reset_sessions!
    puts 'After callback executed 22'
  end

  it "export geofle: #{file_name}" do
    find_link(link_name).click
    sleep 5
    expect(File.exist?(export_file_path)).to be_truthy, "Error: no exported geofile not found - #{export_file_path}"
  end

end
