require "test_helper"

describe Invitation do
  helper_objects

  let(:invitation) { create :invitation, sender: peter, receiver: allen, card: album, status: Invitation::STATUS[:pending] }

  describe ".accept" do
    before do
      invitation.accept
    end

    it "updates the status of the invitation" do
      invitation.status.must_equal Invitation::STATUS[:accepted]
    end

    it "adds the card into the receiver's joined_albums array" do
      allen.joined_albums.must_include album
    end

    it "adds the receiver to the card's followers list" do
      album.followers.must_include allen
    end
  end

  describe ".rejected" do
    it "updates the invitation's status to rejected" do
      invitation.reject
      invitation.status.must_equal Invitation::STATUS[:rejected]
    end
  end
end
