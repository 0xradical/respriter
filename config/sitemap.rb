SitemapGenerator::Sitemap.default_host = "https://classpert.com"
SitemapGenerator::Sitemap.create do

  add('/', {
    changefreq: 'weekly',
    alternate: [
      {
        href: 'https://pt-BR.classpert.com',
        lang: 'pt-BR'
      },
      {
        href: 'https://es.classpert.com',
        lang: 'es'
      }
    ]
  })

  add('/privacy-policy', {
    changefreq: 'monthly',
    alternate: [
      {
        href: 'https://pt-BR.classpert.com/privacy-policy',
        lang: 'pt-BR'
      },
      {
        href: 'https://es.classpert.com/privacy-policy',
        lang: 'es'
      }
    ]
  })

  add('/terms-and-conditions', {
    changefreq: 'monthly',
    alternate: [
      {
        href: 'https://pt-BR.classpert.com/terms-and-conditions',
        lang: 'pt-BR'
      },
      {
        href: 'https://es.classpert.com/terms-and-conditions',
        lang: 'es'
      }
    ]
  })

  add('/search', {
    changefreq: 'daily',
    alternate: [
      {
        href: 'https://pt-BR.classpert.com/search',
        lang: 'pt-BR'
      },
      {
        href: 'https://es.classpert.com/search',
        lang: 'es'
      }
    ]
  })

  Course.unnest_curated_tags.distinct.map {|c| c.tag.dasherize } .each do |tag|
    add("/#{tag}", {
      changefreq: 'weekly', 
      priority: 1,
      alternate: [
        {
          href: "https://pt-BR.classpert.com/#{tag}",
          lang: 'pt-BR'
        },
        {
          href: "https://es.classpert.com/#{tag}",
          lang: 'es'
        }
      ]
    })
  end

end
