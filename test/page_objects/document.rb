module PageObjects
  class Document < AePageObjects::Document
    def flash_message(message_type)
      raise NotImplementedError
    end
  end
end
