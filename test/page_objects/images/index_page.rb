module PageObjects
  module Images
    class IndexPage < PageObjects::Document
      path :images

      collection :images, locator: '#TODO', item_locator: '#TODO', contains: ImageCard do
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
        # TODO: node.find(:xpath, "//td[contains(@class, 'js-image-tags')]/following-sibling::td[img[@src='#{url}']]")
        return false unless node.find(:xpath, "//td/img[@src='#{url}']")['src'] == url
        tags == node.find(:xpath, "//td[contains(@class, 'js-image-tags')]").text.split(' ')
      end

      def clear_tag_filter!
        # TODO

        raise NotImplementedError
      end
    end
  end
end
