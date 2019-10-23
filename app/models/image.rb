class Image < ApplicationRecord
  validates :url, presence: true, url: true
end
