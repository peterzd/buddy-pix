namespace :es do
  desc "import data into elastic"

  task :import => :environment do
    Album.import
    Photo.import
  end
end
