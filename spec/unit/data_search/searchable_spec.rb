require 'spec_helper'
require 'data_search/searchable'

class TestSearchableClass
  extend DataSearch::Searchable

  file = File.read('./spec/test_data/elements.json')

  def self.id_key
    @id_key ||= :name
  end

  elements_data = JSON.parse(file, symbolize_names: true)

  create_indexes(elements_data, id_key)
end

describe DataSearch::Searchable do
  describe 'element_hash' do
    it 'should create element_hash' do
      expect(TestSearchableClass.element_hash).not_to be_nil
    end

    it 'should create element_hash with correct count' do
      expect(TestSearchableClass.element_hash.count).to eq 9
    end

    it 'element_hash could find element by id_key' do
      expect(TestSearchableClass.element_hash[:sulfax]).to eq(
        {
          _id: 107,
          url: 'http://initech.zendesk.com/api/v2/organizations/107.json',
          external_id: '773cc8fd-12e6-4f0b-9709-a370d98ee2e0',
          name: 'Sulfax',
          domain_names: [
            'comvey.com',
            'quantalia.com',
            'velity.com',
            'enormo.com'
          ],
          created_at: '2016-01-12T01:16:06 -11:00',
          details: 'MegaCörp',
          shared_tickets: true,
          tags: %w[
            Travis
            Clarke
            Glenn
            Santos
          ]
        }
      )
    end
  end

  describe 'search_hash' do
    it 'should create search_hash' do
      expect(TestSearchableClass.search_hash).not_to be_nil
    end

    it 'should create search_hash with correct indexes count' do
      expect(TestSearchableClass.search_hash.count).to eq 8
    end

    it 'should have integer inverted index _id point to id_key :name' do
      expect(TestSearchableClass.search_hash[:_id][:'102']).to eq [:nutralab]
    end

    it 'should have string inverted index external_id point to id_key :name' do
      expect(TestSearchableClass.search_hash[:external_id][:'f6eb60ad-fe37-4a45-9689-b32031399f93'])
        .to eq [:xylar]
    end

    it 'should have array inverted index tags point to id_key :name' do
      expect(TestSearchableClass.search_hash[:tags][:lindsay]).to eq [:plasmos]
    end
  end
end
