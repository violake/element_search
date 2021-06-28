require 'data_search/base_search'
require 'data_search/with_association'
require 'json'

module DataSearch
  class UserSearch < BaseSearch
    extend ::DataSearch::WithAssociation

    file = File.read('./lib/data_source/users.json')

    users_data = JSON.parse(file, symbolize_names: true)

    create_indexes(users_data, id_key)

    def private_class_method.associate_elements_map
      [{
        element_search: OrganizationSearch,
        element_key: :organization_id,
        search_key: :_id,
        display_key: :organization
      }]
    end
  end
end
