require "test_helper"

describe AlbumsController do
  helper_objects

  describe "GET index" do
    describe "not logged in user" do
      it "can not access the page" do
        get :index
        assert_redirected_to root_path
      end
    end

    describe "logged in user" do
      before do
        sign_in peter
      end

      it "can access the page" do
        get :index
        assert_response :success
      end

      it "lists all non-hidden albums" do
        album.update creator: peter
        hidden_card =  create :album, caption: "this is hidden album", name: "hidden album", private: false, hidden: true, creator: peter
        get :index
        assigns[:albums].wont_include hidden_card
      end
    end
  end

  describe "GET new" do
    describe "not logged in" do
      it "redirects to root path" do
        get :new
        assert_redirected_to root_path
      end
    end

    describe "logged in user" do
      before do
        sign_in peter
      end

      it "can access the page" do
        get :new
        assert_response :success
      end
    end
  end

  describe "GET show" do
    describe "the card is public" do
      before do
        public_album.update creator: peter
      end

      it "everyone can access the page" do
        get :show, id: public_album.id
        assert_response :success
      end
    end

    describe "the card is private" do
      before do
        private_album.update creator: peter
      end

      describe "not logged in user" do
        it "can not access the page" do
          get :show, id: private_album.id
          assert_redirected_to root_path
        end
      end

      describe "logged in as the creator" do
        before do
          sign_in peter
        end

        it "can access the page" do
          get :show, id: private_album.id
          assert_response :success
        end
      end

      describe "logged in as the follower" do
        before do
          allen.joins_album private_album
          sign_in allen
        end

        it "can access the page" do
          get :show, id: private_album.id
          assert_response :success
        end
      end

      describe "logged in as the other user" do
        before do
          sign_in allen
        end

        it "can access the page" do
          get :show, id: private_album.id
          assert_redirected_to root_path
        end
      end
    end
  end

  describe "POST create album" do
    describe "not logged in" do
      it "can not access the page" do
        post :create, album: attributes_for(:album, caption: "album caption", name: "first album", private: true)
        assert_redirected_to root_path
      end
    end

    describe "logged in user" do
      before do
        sign_in peter
      end

      it "creates a new card" do
        assert_difference('Album.count') do
          post :create, album: attributes_for(:album, caption: "album caption", name: "first album", private: true)
        end
        assert_redirected_to cards_path
      end

      it "sets the creator as the current_user" do
        post :create, album: attributes_for(:album, caption: "album caption", name: "first album", private: true)
        Album.last.creator.must_equal peter
      end
    end
  end

  describe "POST hide_card" do
    before do
      album.update creator: peter
    end

    describe "logged in as normal user" do
      before do
        sign_in allen
      end

      it "can not hide this card" do
        xhr :post, :hide_card, id: album.id
        album.reload.wont_be :hidden
      end
    end

    describe "logged in as the owner of the card" do
      before do
        sign_in peter
      end

      it "can hide the card" do
        xhr :post, :hide_card, id: album.id
        album.reload.must_be :hidden
      end
    end

    describe "logged in as Admin" do
      before do
        sign_in admin
      end

      it "can hide the card" do
        xhr :post, :hide_card, id: album.id
        album.reload.must_be :hidden
      end
    end
  end

  describe "POST view_card" do
    before do
      album.update creator: peter, hidden: true
    end

    it "makes a hidden card to be visible to world" do
      sign_in peter
      xhr :post, :view_card, id: album.id
      album.reload.wont_be :hidden
    end
  end

  describe "GET hidden cards" do
    before do
      @cards = create_list :album, 5, caption: "non hidden card", name: "new card", private: false, creator: peter
    end

    describe "the user does not have any hidden cards" do
      before do
        sign_in peter
      end

      it "redirects to the root page" do
        get :hidden_cards
        assert_redirected_to root_path
      end
    end

    describe "the user has some hidden cards" do
      before do
        @hidden_cards = create_list :album, 5, caption: "non hidden card", name: "new card", private: false, hidden: true, creator: peter
        sign_in peter
      end

      it "access the page" do
        get :hidden_cards
        assert_response :success
      end

      it "lists all the user's hidden cards" do
        get :hidden_cards
        assigns[:albums].must_match_array @hidden_cards
      end
    end
  end
end
