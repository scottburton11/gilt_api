$:.unshift "."
$:.unshift "lib"

require 'sinatra/base'
require 'json'
require 'active_support/core_ext'
require 'active_support/inflector'
require 'builder'
require 'rabl'

Dir[File.expand_path(File.join(File.expand_path(__FILE__), "..", "config", "initializers", "**", "*.rb"))].each {|file| require file }

Rabl.register!

require 'lib/gilt'
require 'lib/server'

use Rack::Reloader
run Gilt::Products.new