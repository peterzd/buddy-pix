namespace :image do
  desc "reprocess image to make into four styles"
  task :reprocess => :environment do
    Image.all.each do |image|
      p "processing image: #{image.id}"
      if image.picture_file_name
        path = "public" + image.picture.url(:original).slice(/.*\d\/original/) + "/#{image.picture_file_name}"
        image.update picture: File.new(path)
      else
        p "image has no picture"
      end
    end
  end

  desc "reprocess one image"
  task :reprocess_one, [:image_id] => :environment do |t, args|
    image = Image.find args.image_id.to_i
    p "processing image: #{image.id}"
    if image.picture_file_name
      path = "public" + image.picture.url(:original).slice(/.*\d\/original/) + "/#{image.picture_file_name}"
      image.update picture: File.new(path)
    else
      p "image has no picture"
    end
  end
end
