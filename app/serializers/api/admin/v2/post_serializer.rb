module Api
  module Admin
    module V2
      class PostSerializer < ResourceSerializer

        link :self do |object|
          api_admin_v2_post_url(object.id, host: host)
        end

        attributes *Post.attribute_names - [:meta]

        attribute :meta do |object|
          object.meta.to_json.to_s
        end

        belongs_to :admin_account
        has_many  :images

      end
    end
  end
end
