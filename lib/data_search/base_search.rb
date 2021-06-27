require 'data_search/searchable'

## DataSearch::BaseSearch Class
#
#  Aim: search element by key value
#
#  Design: with the searchable module, it just need to search the element_hash or search_hash
#
#  Concern: 1. made assumption that all element keys are used for searching
#           2. return empty array when could not find element by search value
#              this will also prevent and edge case when there are error associations
#

module DataSearch
  class BaseSearch
    extend ::DataSearch::Searchable

    class << self
      def search_keys
        search_hash.keys.unshift id_key
      end

      def valid_search_key?(key)
        search_keys.include?(key)
      end

      def find_elements_by_search_key(key, value)
        unless valid_search_key?(key)
          raise NoSearchKeyError,
                "Key(#{key}) is invalid for #{name}"
        end

        if key == id_key
          find_elements_by_id_key(value)
        else
          find_elements_by_search_hash_key(key, value)
        end
      end

      private

      def id_key
        @id_key ||= :_id
      end

      def find_elements_by_id_key(id)
        element = element_hash[id]
        element.nil? ? [] : [element_hash[id]]
      end

      def find_elements_by_search_hash_key(key, value)
        ids = search_hash[key][value] || []
        element_hash.values_at(*ids)
      end
    end
  end

  class NoSearchKeyError < StandardError; end
end
