require "test_helper"

class PhotosServiceTest < ActiveSupport::TestCase
  helper_objects

  test '.save_photo' do
    User.destroy_all
    allen.joins_album album
    photo = build :photo, title: "test photo", description: "this is a test photo", album: album, creator: allen
    PhotosService.new(photo).save_photo

    peter_noti = peter.notifications.last
    assert_equal peter_noti.maker, allen
    assert_equal peter_noti.action, Notification::ACTION[:post_photo]
    assert_equal peter_noti.object, photo
    assert_equal peter_noti.receiver, peter

    allen_noti = allen.notifications.last
    assert_equal allen_noti.maker, allen
    assert_equal allen_noti.action, Notification::ACTION[:post_photo]
    assert_equal allen_noti.object, photo
    assert_equal allen_noti.receiver, allen
  end
end

