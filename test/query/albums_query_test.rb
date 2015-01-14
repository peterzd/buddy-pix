require "test_helper"

describe AlbumsQuery do
  helper_objects

  let(:private_card_followed) { create :album, name: "private album followed", private: true, creator: peter }
  let(:private_card_unfollowed) { create :album, name: "private album unfollowed", private: true, creator: peter }
  let(:public_card_followed) { create :album, name: "public album followed", private: false, creator: peter }
  let(:public_card_unfollowed) { create :album, name: "public album unfollowed", private: false, creator: peter }

  describe ".unfollowed_cards_by(user)" do
    before do
      [private_card_followed, private_card_unfollowed, public_card_followed, public_card_unfollowed]
      allen.joins_album private_card_followed
      allen.joins_album public_card_followed
    end

    it "does not return the user followed cards" do
      AlbumsQuery.unfollowed_cards_by(allen).wont_include private_card_followed
      AlbumsQuery.unfollowed_cards_by(allen).wont_include public_card_followed
    end

    it "returns the user's unfollowed cards" do
      AlbumsQuery.unfollowed_cards_by(allen).must_include public_card_unfollowed
    end

    it "does not return private unfollowed cards" do
      AlbumsQuery.unfollowed_cards_by(allen).wont_include private_card_unfollowed
    end

  end

end
