class Resource < ApplicationRecord
  belongs_to :dataset
  has_many   :resource_versions, dependent: :destroy

  serialize :kind,      Serializers::Symbol
  serialize :status,    Serializers::Symbol
  serialize :content,   Serializers::SymbolizedHash
  serialize :relations, Serializers::SymbolizedHash

  BASE_62 = [*(0..9).map(&:to_s), *('a'..'z'), *('A'..'Z')].map(&:to_sym)

  def as_json(**options)
    {
      id:        id,
      status:    status,
      content:   content,
      relations: relations
    }
  end

  def self.update_content_in_batch(id_and_contents)
    query = update_content_query id_and_contents
    ApplicationRecord.connection.execute(query).cmd_tuples
  end

  def self.missing_ids(ids)
    sql_ids = ApplicationRecord.sanitize_sql ['ARRAY[?]', ids]
    query = %{
      SELECT
        unnested_id
      FROM unnest(#{sql_ids}) AS unnested_id
      LEFT JOIN resources ON
        resources.id = unnested_id::uuid
      WHERE
        resources.id IS NULL;
    }
    ApplicationRecord.connection.execute(query).values.flatten
  end

  def self.update_content_query(id_and_contents)
    sql_arguments = ApplicationRecord.sanitize_sql ['(?)::json', id_and_contents.to_json]
    %{
      UPDATE resources
      SET content = app.jsonb_merge(resources.content, id_and_content.value::jsonb - 'id')
      FROM json_array_elements(#{sql_arguments}) AS id_and_content
      WHERE
        (id_and_content.value->>'id')::uuid = resources.id;
    }
  end

  def self.digest(n, carry = [])
    return carry.join if n == 0
    index = n%62
    carry.unshift BASE_62[index]
    digest n/62, carry
  end
end
