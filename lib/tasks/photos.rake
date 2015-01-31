namespace :photos do
  desc "set all photos hidde to false"
  task :set_false => :environment do
    Photo.unscoped.update_all hidden: false
    puts "done"
  end
end
