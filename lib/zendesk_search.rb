# frozen_string_literal: true

require 'data_search/ticket_search'
require 'data_search/user_search'
require 'data_search/organization_search'
require 'zendesk_search_cli'

class ZendeskSearch
  NEXT_VALUE_OR_NEXT_SEARCH = "try nother value? or type 'next' to start a new search"
  ENTER_SEARCH_VALUE = 'Enter search value'
  ENTER_SEARCH_TERM = 'Enter search term'
  EMPTY_RESULT = 'No Result Found'

  def initialize
    @element_search_id = nil
    @search_field = nil
  end

  def start
    ZendeskSearchCli.new(search_key_hint, searchable_fields).start do |command|
      case true # rubocop:disable Lint/LiteralAsCondition
      when search_field_selected?
        search_elements(command)
        puts NEXT_VALUE_OR_NEXT_SEARCH
      when element_search_selected?
        select_search_field(command)
        puts ENTER_SEARCH_VALUE
      else
        select_element_search(command)
        puts ENTER_SEARCH_TERM
      end
    rescue StandardError => e
      puts e.message
    end
  end

  private

  def search_elements(value)
    result = if element_search.respond_to?(:find_elements_include_association)
               element_search.find_elements_include_association(@search_field, value)
             else
               element_search.find_elements_by_search_key(@search_field, value)
             end

    if result.empty?
      puts EMPTY_RESULT
    else
      puts JSON.pretty_generate(result)
    end
  end

  def search_field_selected?
    element_search_selected? && !@search_field.nil?
  end

  def element_search_selected?
    !@element_search_id.nil?
  end

  def select_element_search(id)
    raise IncorrectSearchElementError, "Incorrect search id(#{id})" unless element_search_map[id]

    @element_search_id = id
  end

  def select_search_field(field)
    unless element_search.valid_search_key?(field)
      raise UnknownSearchField,
            "Field(#{field}) is not valid!"
    end

    @search_field = field
  end

  def element_search
    element_search_map[@element_search_id]
  end

  def clear_elemenet_search
    @element_search_id = nil
    @search_field = nil
  end

  def element_search_map
    {
      '1': ::DataSearch::UserSearch,
      '2': ::DataSearch::TicketSearch,
      '3': ::DataSearch::OrganizationSearch
    }
  end

  def search_key_hint
    element_search_hints =
      element_search_map.inject('') do |hints, (search_id, element_search)|
        "#{hints}#{search_id}) #{element_search_display_name(element_search)} or "
      end[0..-4]

    "Select #{element_search_hints}"
  end

  def searchable_fields
    element_search_map.values.map do |element_search|
      display_searchable_fields(element_search)
    end
  end

  def element_search_display_name(element_search)
    "#{element_search.name.split('::').last.delete_suffix('Search')}s"
  end

  def display_searchable_fields(element_search)
    line = "----------------------------------\n"

    search_fields = element_search.search_keys.inject('') do |keys, key|
      "#{keys}#{key}\n"
    end

    "#{line}Search #{element_search_display_name(element_search)} with\n#{search_fields}"
  end
end

class IncorrectSearchElementError < StandardError; end

class UnknownSearchField < StandardError; end
