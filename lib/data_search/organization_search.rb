require 'data_search/base_search'
require 'data_search/with_association'
require 'json'

module DataSearch
  class OrganizationSearch < BaseSearch
    extend ::DataSearch::WithAssociation

    file = File.read('./lib/data_source/organizations.json')

    organizations_data = JSON.parse(file, symbolize_names: true)

    create_indexes(organizations_data, id_key)

    def private_class_method.associate_elements_map
      [{
        element_search: UserSearch,
        element_key: :_id,
        search_key: :organization_id,
        display_key: :users
      },
       {
         element_search: TicketSearch,
         element_key: :_id,
         search_key: :organization_id,
         display_key: :tickets
       }]
    end
  end
end
