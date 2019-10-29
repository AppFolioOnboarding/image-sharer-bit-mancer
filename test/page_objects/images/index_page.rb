module PageObjects
  module Images
    class IndexPage < PageObjects::Document
      path :images

      collection :images, locator: '.js-images-index', item_locator: '.js-image-card', contains: ImageCard do
        def view!
          # TODO

          raise NotImplementedError
        end
      end

      def add_new_image!
        node.click_on('Create Image')
        stale!
        window.change_to(NewPage)
      end

      def showing_image?(url:, tags: nil)
        begin
          tag_td = node.find(:xpath, "//td[a[img[@src='#{url}']]]/following-sibling::td[contains(@class, 'js-image-tags')]")
          return tag_td.text == tags.join(' ') if tags.present?
          true
        rescue Capybara::ElementNotFound
          false
        end
      end

      def clear_tag_filter!
        node.click_on('View all images')
        stale!
        window.change_to(IndexPage)
      end
    end
  end
end
