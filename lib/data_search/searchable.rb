require 'inverted_index/base_index'
require 'inverted_index/array_index'

## DataSearch::Searchable Class
#
#  Aim: load data and create inverted indexes
#
#  Design: an element hash to save original elements with unique id as key
#          an search hash to save all inverted indexes with id array as value
#          there is a default map for inverted index converters and can pass in as necessary
#          id_key to be configurable
#
#  Concern: 1. made an assumption that don't care about edge case for attr type of element
#           when adding indexes so added a fallback converter cover unknown/unmapped attr class
#           2. made an assumption that id_key is unique
#

module DataSearch
  module Searchable
    attr :search_hash, :element_hash

    def create_indexes(element_arr,
                       id_key,
                       inverted_index_converters = default_inverted_index_converters)
      @search_hash = {}
      @element_hash = {}

      element_arr.each do |element|
        id = element[id_key].to_s.downcase.to_sym
        @element_hash[id] = element

        element.except(id_key).each do |key, value|
          inverted_index_converter =
            inverted_index_converters[value.class.to_s.to_sym] || fallback_converter

          inverted_index_converter.add_new_pair_to_search_hash(@search_hash, key, value, id)
        end
      end
    end

    private

    def default_inverted_index_converters
      {
        Array: ::InvertedIndex::ArrayIndex
      }
    end

    def fallback_converter
      InvertedIndex::BaseIndex
    end
  end
end
