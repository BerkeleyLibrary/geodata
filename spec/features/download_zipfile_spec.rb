require 'rails_helper'
require 'zip'
require 'fileutils'

RSpec.describe 'Original Shapefile link from download section' do
  let(:download_dir) { CommonHelpers::DOWNLOAD_TMP_PATH }
  let(:zip_file_path) { File.join(download_dir, 'data.zip') }
  let(:all_files) { Dir.glob(File.join(download_dir, '*.crdownload')) + [zip_file_path] }

  around(:example) do |ex|
    rm_files(all_files)
    ex.run
    rm_files(all_files)
  end
  before { view_record(CommonHelpers::PUBLIC_RECORD_ID) }

  context 'when downloading the original shapefile' do
    before { click_download_button }

    it 'download and validate download file' do
      find_link('Original Shapefile').click
      verify_download(zip_file_path)
    end
  end

end
