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

      it "lists all users but no Admin user nor the current_user self" do
        get :new, card_id: album.id
        assigns[:users].wont_include admin
        assigns[:users].wont_include peter
        assigns[:users].must_match_array [allen, another_user]
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
end
