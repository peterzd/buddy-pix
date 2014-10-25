require "test_helper"

describe DashboardController do
  let(:peter) { create :user, email: "peter@test.com", password: "11111111", first_name: "peter", last_name: "zhao" }

  describe "GET account_settings" do
    describe "did not sign in" do
      it "can not access the page" do
        get :account_settings
        assert_redirected_to root_path
      end
    end

    describe "logged in user" do
      before do
        sign_in peter
      end

      it "can access the page" do
        get :account_settings
        assert_response :success
      end
    end
  end
end
