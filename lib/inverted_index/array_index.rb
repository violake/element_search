require 'inverted_index/base_index'

## InvertedIndex::ArrayIndex Class
#
#  Aim: convert array value to inverted index
#
#  Design: use each value of element attr array as hash key in the inverted_hash
#          and element_ids as as the array value
#

module InvertedIndex
  class ArrayIndex < BaseIndex
    def self.add_new_pair_to_search_hash(search_hash, key, arr_value, element_id)
      arr_value.each do |value|
        super(search_hash, key, value, element_id)
      end
    end
  end
end
