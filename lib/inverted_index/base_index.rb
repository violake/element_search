## InvertedIndex::BaseIndex Class
#
#  Aim: convert ordinary value to inverted index
#
#  Design: use element attr value as hash key in the inverted_hash
#          and element_ids as as the array value
#

module InvertedIndex
  class BaseIndex
    def self.add_new_pair_to_search_hash(search_hash, key, value, element_id)
      search_value = value.to_s.downcase.to_sym

      if search_hash[key].nil?
        search_hash[key] = { search_value => [element_id] }
      else
        (search_hash[key][search_value] ||= []) << element_id
      end
    end
  end
end
