module PageObjects
  module Images
    class ShowPage < PageObjects::Document
      path :image

      element :image_url, locator: '.js-image'
      element :tags, locator: '.js-tags'

      def image_url
        node.find('.js-image')['src']
      end

      def tags
        node.find('.js-tags').text.split(', ')
      end

      def delete
        node.find('.js-delete-link').click

        yield node.driver.browser.switch_to.alert
      end

      def delete_and_confirm!

        self.delete do |confirm_dialog|
          confirm_dialog.accept
        end

        stale!

        window.change_to(IndexPage)
      end

      def go_back_to_index!
        node.click_on('View all images')
        stale!
        window.change_to(IndexPage)
      end
    end
  end
end
