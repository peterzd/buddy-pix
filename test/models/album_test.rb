require "test_helper"

describe Album do
  let(:private_album) { create :album, name: "private album", private: true }
  let(:public_album) { create :album, name: "public album", private: false }

  it "creates two record in DB" do
    [private_album, public_album]
    Album.count.must_equal 2
  end

  it "tells if an album is pirvate or public" do
    private_album.must_be :private?
    public_album.wont_be :private?
  end

end
