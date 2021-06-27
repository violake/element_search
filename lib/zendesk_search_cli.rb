# frozen_string_literal: true

## ZendeskSearchCli Class
#
#  Aim: Create a CLI frame work
#
#  Design: a search cli that has help and quit command can also run command by given block
#
#  Concern: made an assumption for 'Enter' to continue as `Enter` is kind of difficult to handle
#           in current structure
#           so add 'next' to start a new search
#

class ZendeskSearchCli
  COMMAND_PROMPT = '>'
  COMMAND_CONTINUE = :next
  COMMAND_QUIT = :quit
  COMMAND_EXIT_HINT = 'Exit Zendesk Search'

  HELP_MESSAGE = <<~HEREDOC

    =========================================================================================
    Welcome to Zendesk Search
    Type 'quit' to exit at any time, 'next' to start a new search, Press 'Enter' to continue
    =========================================================================================

    \s\sSelect search options
    \s\s\s\s* Press 1 to search zendesk
    \s\s\s\s* Press 2 to view a list of searchable fields
    \s\s\s\s* Type 'quit' to exit

  HEREDOC

  def initialize(search_key_hint, searchable_fields)
    @search_key_hint = search_key_hint
    @searchable_fields = searchable_fields
  end

  def start
    puts HELP_MESSAGE

    loop do
      print COMMAND_PROMPT

      command = gets.chomp.downcase.to_sym

      case command
      when COMMAND_QUIT
        puts COMMAND_EXIT_HINT
        break
      when COMMAND_CONTINUE
        new_search
      else
        in_search? ? yield(command, @in_search) : options(command)
      end
    end
  end

  private

  def new_search
    if in_search?
      puts 'New search'
      @in_search = false
    end
  end

  def set_in_search
    @in_search = true
  end

  def in_search?
    @in_search
  end

  def options(command)
    case command
    when :'1'
      puts @search_key_hint
      set_in_search
    when :'2'
      puts @searchable_fields
    else
      puts "Error Input: '#{command}'"
    end
  end
end
