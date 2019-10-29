module PageObjects
  module Images
    class NewPage < PageObjects::Document
      path :new_image
      path :images

      form_for :image do
        element :url, locator: '.js-url'
        element :tags, locator: '.js-tags'
      end

      def create_image!(url: nil, tags: nil)
        self.url.set url
        self.tags.set tags

        node.click_on('Create Image')

        if url =~ /https?:\/\//
          stale!
          window.change_to(ShowPage)
        else
          window.change_to(NewPage)
        end
      end
    end
  end
end
