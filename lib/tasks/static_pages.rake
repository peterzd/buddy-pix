namespace :static_pages do
  desc "initialize three pages"
  task :init => :environment do
    terms = StaticPages.create name: "terms", content: "this is terms content"
    about_us = StaticPages.create name: "about_us", content: "this is about us content"
    privacy = StaticPages.create name: "privacy", content: "this is privacy content"
  end
end
