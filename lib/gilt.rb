require 'yajl/json_gem'
require 'pathname'

require 'i18n'

require 'bundler'
Bundler.require

require 'active_support/core_ext'
require 'active_support/inflector'

module Gilt
  def root
    @root ||= Pathname.new(File.expand_path(File.join(__FILE__, "..", "..")))
  end
  module_function :root

  class App
    DatabaseFile = Gilt.root + "db" + "gilt_api.sqlite3"

    class << self
      def load
        load_initializers
        load_database
      end

      def load_initializers
        Dir[Gilt.root + "config" + "initializers" + "**" + "*.rb"].each {|file| require file }
      end

      attr_reader :db
      def load_database
        @db ||= Sequel.sqlite(DatabaseFile.to_s)
      end
    end
  end
end

Gilt::App.load

require 'models/designer'
require 'models/product'
require 'models/category'
require 'gilt/importer'
require 'services/gilt/request_helper'
require 'services/gilt/sale'
require 'services/gilt/product'