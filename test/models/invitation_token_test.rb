require "test_helper"

describe InvitationToken do
  helper_objects

  describe "#generate_token" do
    before do
      to_url = "peter@test123.com"
      @token = InvitationToken.generate_token(action: album, info: to_url, invitation_mode: InvitationToken::MODE[:email], inviter: peter)
    end

    it "creates a new invitation_token instance" do
      InvitationToken.count.must_equal 1
    end

    it "returns a rendom token" do
      @token.wont_be :nil?
    end
  end
end
