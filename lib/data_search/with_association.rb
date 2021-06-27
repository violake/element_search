## DataSearch::WithAssociation Class
#
#  Aim: search element with association by key value
#
#  Design: with the association_map defined in element search class and searchable module
#          it just need to search associated element search class and do not need to worried about
#          edge case that the foreign key is wrong as it will just get empty array.
#
#

module DataSearch
  module WithAssociation
    def find_elements_include_association(key, value)
      elements = find_elements_by_search_key(key, value)

      elements.map do |element|
        add_associate_elements(element)
      end
    end

    private

    def associate_elements_map
      raise NoAssociationDefinedError
    end

    def add_associate_elements(element)
      return nil if element.nil?

      associate_elements_map.each_with_object(element) do |element_map, new_element|
        associate_element_search = element_map[:element_search]
        associate_search_key = element_map[:search_key]
        associate_search_value = element[element_map[:element_key]].to_s.downcase.to_sym

        new_element.merge!(element_map[:display_key] =>
          associate_element_search.find_elements_by_search_key(
            associate_search_key,
            associate_search_value
          ))
      end
    end
  end

  class NoAssociationDefinedError < StandardError; end
end
