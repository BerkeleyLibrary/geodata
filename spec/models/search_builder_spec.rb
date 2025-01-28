require 'rails_helper'

RSpec.describe SearchBuilder do
  describe 'inherited behaviors' do
    it 'includes Blacklight::Solr::SearchBuilderBehavior' do
      expect(SearchBuilder.included_modules).to include(Blacklight::Solr::SearchBuilderBehavior)
    end

    it 'includes Geoblacklight::SuppressedRecordsSearchBehavior' do
      expect(SearchBuilder.included_modules).to include(Geoblacklight::SuppressedRecordsSearchBehavior)
    end
  end
end
