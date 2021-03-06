module PageObjects
  module Images
    class IndexPage < PageObjects::Document
      path :images

      collection :images, locator: '.js-images-index', item_locator: '.js-image-card', contains: ImageCard do
        def view!
          image_link = element(locator: '.js-image-link')
          image_link.node.click

          stale!
          window.change_to(ShowPage)
        end
      end

      def add_new_image!
        node.click_on('Create Image')
        stale!
        window.change_to(NewPage)
      end

      def showing_image?(url:, tags: nil)
        tag_td = node.find(:xpath, "//td[a[img[@src='#{url}']]]/following-sibling::td[contains(@class, 'js-image-tags')]")
        return tag_td.text == tags.join(' ') if tags.present?

        true
      rescue Capybara::ElementNotFound
        false
      end

      def clear_tag_filter!
        node.click_on('View all images')
        stale!
        window.change_to(IndexPage)
      end
    end
  end
end
