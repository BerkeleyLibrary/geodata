require 'rails_helper'

RSpec.describe SolrDocument do
  it 'is keyed on id' do
    expect(SolrDocument.unique_key).to eq 'id'
  end

  describe 'extensions' do
    let(:extensions) { SolrDocument.registered_extensions.pluck :module_obj }

    it 'uses the email extension' do
      expect(extensions).to include Blacklight::Document::Email
    end

    it 'uses the sms extension' do
      expect(extensions).to include Blacklight::Document::Sms
    end

    it 'uses the dublin core extension' do
      expect(extensions).to include Blacklight::Document::DublinCore
    end
  end
end
