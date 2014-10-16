require "test_helper"

describe Album do
  let(:album) { Album.new }

  it "must be valid" do
    album.must_be :valid?
  end


end
