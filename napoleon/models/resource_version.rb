class ResourceVersion < ApplicationRecord
  belongs_to :dataset
  belongs_to :resource

  serialize :content,   Serializers::SymbolizedHash
  serialize :relations, Serializers::SymbolizedHash

  def as_json(**options)
    {
      id:                resource_id,
      status:            status,
      content:           content,
      relations:         relations,
      global_sequence:   id,
      dataset_sequence:  dataset_sequence,
      resource_sequence: sequence
    }
  end
end
