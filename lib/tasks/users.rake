namespace :users do
  desc "set users' role"
  task :set_role => :environment do
    User.all.each do |u|
      u.update role: :normal
      p "updated user: #{u.email}"
    end

    admin = User.where(type: "AdminUser").first
    admin.update role: :admin
    p "updated admin: #{admin.email}"
  end

end
