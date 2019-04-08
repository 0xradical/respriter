SitemapGenerator::Sitemap.default_host = "https://classpert.com"
SitemapGenerator::Sitemap.create do

  add('/', {
    changefreq: 'weekly',
    alternate: {
      href: 'https://pt-BR.classpert.com',
      lang: 'pt-BR'
    }
  })

  add('/privacy-policy', {
    changefreq: 'monthly',
    alternate: {
      href: 'https://pt-BR.classpert.com/privacy-policy',
      lang: 'pt-BR'
    }
  })

  add('/terms-and-conditions', {
    changefreq: 'monthly',
    alternate: {
      href: 'https://pt-BR.classpert.com/terms-and-conditions',
      lang: 'pt-BR'
    }
  })

  add('/search', {
    changefreq: 'daily',
    alternate: {
      href: 'https://pt-BR.classpert.com/search',
      lang: 'pt-BR'
    }
  })

  NavigationalTag.all.each do |tag|
    add("/#{tag.slugify}", {
      changefreq: 'daily',
      priority: 0.7,
      alternate: {
        href: "https://pt-BR.classpert.com/#{tag.slugify}",
        lang: 'pt-BR'
      }
    })
  end

end
