require "test_helper"

describe StaticPages do
  let(:static_pages) { StaticPages.new }

  it "must be valid" do
    static_pages.must_be :valid?
  end
end
