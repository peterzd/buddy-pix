def helper_objects
  # users
  let(:admin) { create :admin_user, email: "admin@example.com", password: "password", first_name: "admin", last_name: "god" }
  let(:peter) { create :user, email: "peter@test.com", password: "11111111", first_name: "peter", last_name: "zhao" }
  let(:allen) { create :user, email: "allen@test.com", password: "11111111", first_name: "allen", last_name: "wang" }

  # albums (cards)
  let(:album) { create :album, caption: "album caption", name: "first album", private: true }
  let(:private_album) { create :album, name: "private album", private: true }
  let(:public_album) { create :album, name: "public album", private: false }

  # blogs
  let(:blog) { create :blog, title: "test blog", content: "this is content of the blog" }

  # images
  let(:image) { create :image }

  # support
  let(:support) { create :support, sender_name: "peter zhao", subject: "test support", email: "peter@test.com", message: "this is a test support message" }

  # photos
  let(:photo) { create :photo, title: "test photo", description: "this is a new photo" }
end
