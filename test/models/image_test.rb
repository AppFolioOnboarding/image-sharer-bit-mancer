require 'test_helper'

class ImageTest < ActiveSupport::TestCase
  def test_image__valid
    image = Image.new(url: 'https://designerdoginfo.files.wordpress.com/2012/04/puppy-and-adult-dog.jpg')

    assert_predicate image, :valid?
  end

  def test_image__invalid__blank_url
    image = Image.new(url: '')

    refute_predicate image, :valid?
    assert_equal "can't be blank", image.errors.messages[:url].first
  end

  def test_image__invalid__malformed_url
    image = Image.new(url: 'badprotocol://designerdoginfo.files.wordpress.com/2012/04/puppy-and-adult-dog.jpg')

    refute_predicate image, :valid?
    assert_equal 'is not a valid URL', image.errors.messages[:url].first
  end
end
