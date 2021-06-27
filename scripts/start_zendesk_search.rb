#!/usr/bin/env ruby
# frozen_string_literal: true

$LOAD_PATH.unshift('./lib')
require 'zendesk_search_cli'

ZendeskSearchCli.new.start('lailailai', 'fields like this') do |command|
  puts "run command '#{command}'"
end
