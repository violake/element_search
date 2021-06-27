require 'spec_helper'
require 'data_search/base_search'
require 'data_search/searchable'

class TestBaseSearchClass < DataSearch::BaseSearch
  extend DataSearch::Searchable

  file = File.read('./spec/test_data/elements.json')

  elements_data = JSON.parse(file, symbolize_names: true)

  create_indexes(elements_data, id_key)
end

describe DataSearch::BaseSearch do
  describe 'find_elements_by_search_key' do
    it 'should find element with _id as id_key ' do
      expect(TestBaseSearchClass.find_elements_by_search_key(:_id, :'107')).to eq(
        [{
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
        }]
      )
    end

    it 'should find element with name as ordinary search_key ' do
      expect(TestBaseSearchClass.find_elements_by_search_key(:name, :qualitern)).to eq(
        [{
          _id: 106,
          url: 'http://initech.zendesk.com/api/v2/organizations/106.json',
          external_id: '2355f080-b37c-44f3-977e-53c341fde146',
          name: 'Qualitern',
          domain_names: [
            'gology.com',
            'myopium.com',
            'synkgen.com',
            'bolax.com'
          ],
          created_at: '2016-07-23T09:48:02 -10:00',
          details: 'Artisân',
          shared_tickets: false,
          tags: %w[
            Nolan
            Rivas
            Morse
            Conway
          ]
        }]
      )
    end

    it 'should return empty if no element found' do
      expect(TestBaseSearchClass.find_elements_by_search_key(:_id, :'111')).to eq []
    end

    it 'should raise error if search with invalid key' do
      expect { TestBaseSearchClass.find_elements_by_search_key(:some_key, :'111') }
        .to raise_error(DataSearch::NoSearchKeyError)
    end
  end

  describe 'search_keys' do
    it 'should equal to all elements keys' do
      expect(TestBaseSearchClass.search_keys).to eq(
        %i[_id url external_id name domain_names created_at details shared_tickets
           tags]
      )
    end
  end

  describe 'valid_search_key?' do
    it 'should return true if key is valid' do
      expect(TestBaseSearchClass.valid_search_key?(:_id)).to be_truthy
    end

    it 'should return false if key is invalid' do
      expect(TestBaseSearchClass.valid_search_key?(:_ss)).to be_falsey
    end
  end
end
