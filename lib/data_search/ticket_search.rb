require 'data_search/base_search'
require 'data_search/with_association'
require 'json'

module DataSearch
  class TicketSearch < BaseSearch
    extend ::DataSearch::WithAssociation

    file = File.read('./lib/data_source/tickets.json')

    tickets_data = JSON.parse(file, symbolize_names: true)

    create_indexes(tickets_data, id_key)

    # rubocop:disable Metrics/MethodLength
    def private_class_method.associate_elements_map
      [{
        element_search: OrganizationSearch,
        element_key: :organization_id,
        search_key: :_id,
        display_key: :organization
      },
       {
         element_search: UserSearch,
         element_key: :submitter_id,
         search_key: :_id,
         display_key: :submitter
       },
       {
         element_search: UserSearch,
         element_key: :assignee_id,
         search_key: :_id,
         display_key: :assignee
       }]
    end
    # rubocop:enable Metrics/MethodLength
  end
end
