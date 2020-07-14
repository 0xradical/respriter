# frozen_string_literal: true

class ProviderConstraint
  def initialize(allow_blank: false)
    @allow_blank = allow_blank
  end

  def matches?(request)
    provider = request.params[:provider]
    is_provider = Provider.slugged.pluck(:slug).include?(provider)

    @allow_blank ? (provider.blank? || is_provider) : is_provider
  end
end
