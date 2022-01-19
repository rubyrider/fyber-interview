require 'rubygems'
require 'bundler/setup'

require_relative './servers'
require_relative './clients'

Thread.current[:clients] ||= {}

require './stores/clients'
