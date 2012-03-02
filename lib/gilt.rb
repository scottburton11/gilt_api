require 'sqlite3'
require 'sequel'
require 'yajl'
require 'yajl/json_gem'

DatabaseFile = File.expand_path(File.join(File.expand_path(__FILE__), "..", "..", "db", "gilt.sqlite3"))

DB = Sequel.sqlite(DatabaseFile)

module Gilt; end

require 'models/designer'
require 'models/product'
require 'gilt/importer'