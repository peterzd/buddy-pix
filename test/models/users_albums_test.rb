require "test_helper"

describe UsersAlbums do
  let(:users_albums) { UsersAlbums.new }

  it "must be valid" do
    users_albums.must_be :valid?
  end
end
