require "test_helper"

describe InvitationsController do
  helper_objects
  let(:another_user) { create :user, email: "another_user@test.com", password: "11111111" }

  describe "GET new" do
    describe "not logged in user" do
    end

    describe "logged in user" do
      before do
        [admin, peter, allen, another_user]
        sign_in peter
      end
    end

  end

  describe "POST create" do
    describe "not logged in user" do
    end

    describe "logged in user" do
      before do
        sign_in peter
      end

      it "will create invitations for other users" do
        assert_difference "Invitation.count", 2 do
          post :create, user_ids: [allen.id, another_user.id], card_id: album.id
        end

        assert_redirected_to card_path(album)
      end
    end
  end

  describe "GET accept" do
    before do
      @invitation =  create :invitation, sender: peter, receiver: allen, card: album, status: Invitation::STATUS[:pending] 
    end

    it "changes the status of the invitation" do
      xhr :get, :accept, card_id: album.id, id: @invitation.id
      @invitation.reload.status.must_equal Invitation::STATUS[:accepted]
    end
  end

  describe "GET reject" do
    before do
      @invitation =  create :invitation, sender: peter, receiver: allen, card: album, status: Invitation::STATUS[:pending] 
    end

    it "changes the status of the invitation" do
      xhr :get, :reject, card_id: album.id, id: @invitation.id
      @invitation.reload.status.must_equal Invitation::STATUS[:rejected]
    end
  end
end
