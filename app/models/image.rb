class Image < ApplicationRecord
  validates :url, presence: true, url: true

  acts_as_taggable_on :tags
end
