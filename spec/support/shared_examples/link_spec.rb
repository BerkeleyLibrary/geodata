RSpec.shared_examples 'download link invisible' do |text|
  it "it has no link #{text}" do
    expect(page).not_to have_link(text: text)
  end

end

RSpec.shared_examples 'export geofile to local' do |file_name, link_name|
  let(:download_dir) { CommonHelpers::EXPORT_TMP_PATH }
  let(:export_file_path) { File.join(download_dir, file_name) }

  around(:example) do |ex|
    FileUtils.mkdir_p(download_dir)
    rm_files([export_file_path])
    ex.run
    rm_files([export_file_path])
  end

  it "export geofle: #{file_name}" do
    find_link(link_name).click
    sleep 5
    expect(File.exist?(export_file_path)).to be_truthy, "Error: no exported geofile not found - #{export_file_path}"
  end

end
