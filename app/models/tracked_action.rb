class TrackedAction < ApplicationRecord

  upsert_keys [:compound_ext_id]
  belongs_to :enrollment, optional: true

end
