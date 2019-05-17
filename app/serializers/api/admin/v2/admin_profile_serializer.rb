module Api
  module Admin
    module V2

      class AdminProfileSerializer < ResourceSerializer

        attributes :name, :bio
        has_one :avatar

      end

    end
  end
end

