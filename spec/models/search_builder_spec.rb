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

  describe 'facet requests' do
    it 'does not ask Solr to facet internal filter-only fields on every search' do
      facet_fields = CatalogController.blacklight_config.facet_fields

      expect(facet_fields[Settings.FIELDS.GEOMETRY].include_in_request).not_to be true
      expect(facet_fields[Settings.FIELDS.MEMBER_OF].include_in_request).not_to be true
      expect(facet_fields[Settings.FIELDS.SPATIAL_COVERAGE].include_in_request).to be true
    end
  end
end
