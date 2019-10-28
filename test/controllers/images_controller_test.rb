require 'test_helper'

class ImagesControllerTest < ActionDispatch::IntegrationTest

  def test_index
    images = create_tagged_images

    get images_path

    assert_response :ok

    assert_equal 3, images.count
    assert_select 'img[width=?]', '400', count: images.count

    assert_select 'img.js-image-0[src=?]', images[2].url
    assert_select 'img.js-image-1[src=?]', images[1].url
    assert_select 'img.js-image-2[src=?]', images[0].url

    images[0].tag_list.each do |tag|
      assert_select 'td.js-image-tag-2 > a', text: tag
    end

    images[1].tag_list.each do |tag|
      assert_select 'td.js-image-tag-1 > a', text: tag
    end

    assert_select 'td.js-image-tag-0 > a', 0
  end

  def test_index__with_tag__valid_tag
    images = create_tagged_images

    assert_equal 3, images.count

    get images_path, params: { tag: 'dog' }

    assert_response :ok

    assert_select 'img[width=?]', '400', count: 2

    assert_select 'img[src=?]', images[2].url, count: 0
    assert_select 'img.js-image-0[src=?]', images[1].url
    assert_select 'img.js-image-1[src=?]', images[0].url

    assert_select 'td.js-image-tag-0 > a', images[1].tag_list[0]
    assert_select 'td.js-image-tag-0 > a', images[1].tag_list[1]

    assert_select 'td.js-image-tag-1 > a', images[0].tag_list[1]
  end

  def test_index__with_tag__not_matching
    images = create_tagged_images

    assert_equal 3, images.count

    get images_path, params: { tag: 'not a tag' }

    assert_response :ok

    assert_select 'img', 0
    assert_select 'td > a', 0
  end

  def test_new
    get new_image_path

    assert_response :ok
    assert_select 'form', 1
  end

  def test_create__succeed__no_tags
    assert_difference('Image.count', 1) do
      image_params = { url: 'https://designerdoginfo.files.wordpress.com/2012/04/puppy-and-adult-dog.jpg' }
      post images_path, params: { image: image_params }
    end

    assert_image_creation_with_tags 0, 'https://designerdoginfo.files.wordpress.com/2012/04/puppy-and-adult-dog.jpg'
  end

  def test_create__succeed__with_tags
    [%w[dogs], %w[puppy adult], %w[dog puppy awesome], ['this is just one tag']].each do |tags|
      assert_difference('Image.count', 1) do
        image_params = { url: 'https://designerdoginfo.files.wordpress.com/2012/04/puppy-and-adult-dog.jpg',
                         tag_list: tags.join(',') }
        post images_path, params: { image: image_params }
      end

      assert_image_creation_with_tags tags.count, 'https://designerdoginfo.files.wordpress.com/2012/04/puppy-and-adult-dog.jpg'
    end
  end

  def test_create__fail__blank_url
    assert_no_difference('Image.count') do
      image_params = { url: '' }
      post images_path, params: { image: image_params }
    end

    assert_response :unprocessable_entity
    assert_select '.error', "can't be blank"
  end

  def test_create__fail__malformed_url
    assert_no_difference('Image.count') do
      image_params = { url: 'badprotocol://designerdoginfo.files.wordpress.com/2012/04/puppy-and-adult-dog.jpg' }
      post images_path, params: { image: image_params }
    end

    assert_response :unprocessable_entity
    assert_select '.error', 'is not a valid URL'
  end

  def test_show
    image = Image.create(url: 'https://designerdoginfo.files.wordpress.com/2012/04/puppy-and-adult-dog.jpg')
    get image_path(image.id)

    assert_response :ok
    assert_select 'img', 1
  end

  private

  def assert_image_creation_with_tags(tags_count, url)
    assert_equal url, Image.last.url
    assert_equal tags_count, Image.last.tag_list.count
    assert_redirected_to image_path(Image.last)
    assert_equal 'Image successfully saved!', flash[:notice]
  end

  def create_tagged_images
    Image.create(
        [
            { url: 'https://peopledotcom.files.wordpress.com/2017/11/dog.jpg', tag_list: 'dog' },
            { url: 'http://static.businessinsider.com/image/5484d9d1eab8ea3017b17e29/image.jpg', tag_list: 'dog, puppy' },
            { url: 'https://designerdoginfo.files.wordpress.com/2012/04/puppy-and-adult-dog.jpg' }
        ]
    )
  end
end
