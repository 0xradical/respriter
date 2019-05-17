module Api
  module Admin
    module V2
      class ResourceSerializer

        include FastJsonapi::ObjectSerializer

        class << self

          include Rails.application.routes.url_helpers

          def host
            ENV.fetch('HOST') do
              Rails.env.production? ? 'classpert.com' : 'localhost:3000'
            end
          end

        end


      end
    end
  end
end
