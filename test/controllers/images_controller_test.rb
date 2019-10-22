require 'test_helper'

class ImagesControllerTest < ActionDispatch::IntegrationTest
  def test_new
    get new_image_path

    assert_response :ok
    assert_select 'form', 1
  end

  def test_create__succeed
    assert_difference('Image.count', 1) do
      image_params = {url: 'https://designerdoginfo.files.wordpress.com/2012/04/puppy-and-adult-dog.jpg'}
      post images_path, params: {image: image_params}
    end

    assert_redirected_to image_path(Image.last)
    assert_equal 'Image successfully saved!', flash[:notice]
  end

  def test_create__fail__blank_url
    assert_no_difference('Image.count') do
      image_params = {url: ''}
      post images_path, params: { image: image_params }
    end

    assert_response :unprocessable_entity
    assert_select '.error', "can't be blank"
  end

  def test_create__fail__malformed_url
    assert_no_difference('Image.count') do
      image_params = {url: 'badprotocol://designerdoginfo.files.wordpress.com/2012/04/puppy-and-adult-dog.jpg'}
      post images_path, params: { image: image_params }
    end

    assert_response :unprocessable_entity
    assert_select '.error', 'is not a valid URL'
  end

end
