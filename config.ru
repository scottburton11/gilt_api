$:.unshift "."
$:.unshift "lib"

require 'lib/gilt'
require 'lib/server'

use Rack::Reloader
run Gilt::Products.new