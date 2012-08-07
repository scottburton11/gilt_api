$:.unshift ".", "lib"

module MigrationHelper
  def project_root
    File.expand_path(File.join(File.expand_path(__FILE__), ".."))
  end

  def db_root
    File.expand_path(File.join(project_root,  "db", "gilt_api.sqlite3"))
  end
end

namespace :db do
  include MigrationHelper
  task :drop do
    `rm #{db_root}` if File.exists?(db_root)
  end

  task :migrate do
    `sequel -m #{project_root}/db/migrations sqlite://#{db_root}`
  end

  task :seed do
    Rake::Task['products:import'].invoke
  end
end

namespace :products do
  task :import => :environment do
    Gilt::Importer.import
  end

  task :download_images => :environment do
    Product.all.each {|product| product.save_image_file }
  end
end

task :environment do
  require 'lib/gilt'
end

task :default do
  Rake::Task['db:drop'].invoke
  Rake::Task['db:migrate'].invoke
  Rake::Task['db:seed'].invoke
end
