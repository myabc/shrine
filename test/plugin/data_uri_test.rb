require "test_helper"

describe "the data_uri plugin" do
  def setup
    @attacher = attacher { plugin :data_uri, error_message: ->(uri) { "Data URI failed" } }
    @user = @attacher.record
  end

  it "enables caching with a data URI" do
    @user.avatar_data_uri = data_uri

    assert @user.avatar
    refute_empty @user.avatar.read
    assert_equal "image/png", @user.avatar.mime_type
    assert @user.avatar.size > 0
  end

  it "keeps the data uri value if uploading doesn't succeed" do
    @user.avatar_data_uri = data_uri
    assert_equal nil, @user.avatar_data_uri

    @user.avatar_data_uri = "foo"
    assert_equal "foo", @user.avatar_data_uri
  end

  it "defaults content type to text/plain" do
    @user.avatar_data_uri = data_uri(nil)

    assert_equal "text/plain", @user.avatar.mime_type
  end

  it "allows content types with dots in them" do
    @user.avatar_data_uri = data_uri("image/vnd.microsoft.icon")

    assert_equal "image/vnd.microsoft.icon", @user.avatar.mime_type
  end

  it "ignores empty strings" do
    @user.avatar_data_uri = data_uri
    @user.avatar_data_uri = ""

    assert @user.avatar
  end

  it "adds a validation error if data_uri wasn't properly matched" do
    @user.avatar_data_uri = "bla"

    assert_equal ["Data URI failed"], @user.avatar_attacher.errors
  end
end
