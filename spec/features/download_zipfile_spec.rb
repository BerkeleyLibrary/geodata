require 'rails_helper'
require 'zip'
require 'fileutils'

RSpec.describe 'Data.zip File Download' do
  let(:download_dir) { CommonHelpers::DOWNLOAD_TMP_PATH }
  let(:zip_file_path) { File.join(download_dir, 'data.zip') }
  let(:all_files) { Dir.glob(File.join(download_dir, '*.crdownload')) + [zip_file_path] }

  around(:example) do |ex|
    rm_files(all_files)
    ex.run
    rm_files(all_files)
  end
  before { visit_public_record }

  context 'when downloading the original data.zip file' do
    before { click_download_button }

    it 'downloads and validates download file' do
      find_link('Original Shapefile').click
      verify_download(zip_file_path)
    end
  end

end
