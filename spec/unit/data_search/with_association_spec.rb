require 'spec_helper'
require 'data_search/base_search'
require 'data_search/with_association'

class TestWithAssociationClass < DataSearch::BaseSearch
  extend DataSearch::WithAssociation

  file = File.read('./spec/test_data/elements.json')

  def self.id_key
    @id_key ||= :name
  end

  elements_data = JSON.parse(file, symbolize_names: true)

  create_indexes(elements_data, id_key)

  def private_class_method.associate_elements_map
    [{
      element_search: TestAssociationClass,
      element_key: :_id,
      search_key: :element_id,
      display_key: :test_association
    }]
  end
end

class TestAssociationClass < DataSearch::BaseSearch
  extend DataSearch::WithAssociation

  file = File.read('./spec/test_data/element_associations.json')

  elements_data = JSON.parse(file, symbolize_names: true)

  create_indexes(elements_data, id_key)
end

describe DataSearch::WithAssociation do
  describe 'find_elements_include_association' do
    it 'should get element with association by key value' do
      expect(TestWithAssociationClass.find_elements_include_association(:name, :zolarex)).to eq(
        [{
          _id: 108,
          url: 'http://initech.zendesk.com/api/v2/organizations/108.json',
          external_id: 'be72663b-338d-42f4-bd52-cf6584cad674',
          name: 'Zolarex',
          domain_names: [
            'elemantra.com',
            'zizzle.com',
            'miraclis.com',
            'overplex.com'
          ],
          created_at: '2016-07-26T09:35:57 -10:00',
          details: 'Non profit',
          shared_tickets: false,
          tags: %w[
            Rosales
            Middleton
            Garrett
            Page
          ],
          test_association: [
            {
              element_id: 108,
              value: "108's value"
            }
          ]
        }]
      )
    end
  end
end
