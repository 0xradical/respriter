class Dataset < ApplicationRecord
  has_many :resources
  has_many :resource_versions
end
