# frozen_string_literal: true

require_relative '../../lib/hypernova_batch_builder'

module ApplicationHelper
  def current_url_without_query_params
    request.base_url + request.path
  end

  def hypernova_cache_handler(&block)
    builder = HypernovaBatchBuilder.new(@_hypernova_service)
    str = capture(builder, &block)
    builder.replace(str)
  end

  def cache_key_for(objects)
    Digest::MD5.hexdigest(objects.map(&:inspect).join)
  end

  def ftc_asa_course_provider_disclosure(course, options={})
    if ['Udemy', 'Coursera'].include?(course.provider.name)
      tag.p(options) { "This course contains affiliates links, meaning when you click the links and make a purchase, we receive a commission" }
    end
  end

  def alert_alias(name)
    alert_map = {
      notice:  'primary',
      info:    'primary',
      alert:   'error',
      danger:  'error',
      warning: 'secondary',
      success: 'secondary-variant'
    }
    alert_map[name.to_sym]
  end

  # DEPRECATED
  def country_flags
    {
      'en'    => 'us',
      'en-us' => 'us',
      'pt-br' => 'br',
      'es'    => 'es',
      'de'    => 'de',
      'fr'    => 'fr',
      'ja'    => 'jp'
    }
  end

  def country_flag(locale, svg_options = {})
    svg_use('country-flags', country_flags[locale.to_s.downcase], svg_options)
  end

  def omniauth_button(provider:, label:)
    link_to(
      label,
      send("user_account_#{provider}_omniauth_authorize_path")
    )
  end

  def svg_use(sprite_name, vector_name, svg_options = {})
    tag.svg(svg_options) do
      tag.use 'xlink:href': "##{sprite_name}-#{vector_name}"
    end
  end

  def home_controller?
    controller_name.eql?('home')
  end

  def sticky_navbar?
    !(
      %w[home static_pages posts contact_us].include?(controller_name) ||
        devise_controller?
    )
  end

  def link_to_locale(locale, opts = {}, &block)
    en = (locale.to_s == 'en')
    link_to(
      (
        root_url(
          subdomain:
                     (
              if en
                params[:subdomain]
              else
                [locale, params[:subdomain]].join('.').chomp('.')
              end
            )
        )
          .chomp('/') +
          request.path +
          (en ? '?intl=true' : '')
      ),
      opts,
      &block
    )
  end
end
