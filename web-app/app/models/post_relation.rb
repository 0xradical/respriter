# frozen_string_literal: true

class PostRelation < ApplicationRecord
  belongs_to :relation, polymorphic: true
  belongs_to :post
end
