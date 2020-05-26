@bot @rack_test
Feature: A spiderbot requests robots.txt

  In order to be SEO friendly for all subdomains
  When spiderbots request robots.txt
  They get subdomain-specific versions of robots.txt

  Scenario Outline: A spiderbot requests robots.txt
    Given that each subdomain has its specific robots.txt
    When a spiderbot requests robots.txt from "<subdomain>"
    Then the spiderbot gets a robots.txt with content "<sitemap_directive>", "<user_agent_directive>", "<disallow_directive>"

    Examples:
    | subdomain | sitemap_directive                                   | user_agent_directive | disallow_directive   |
    |           | Sitemap: https://classpert.com/sitemap.xml.gz       | User-agent: *        | Disallow: /forward   |
    |   es      | Sitemap: https://es.classpert.com/sitemap.xml.gz    | User-agent: *        | Disallow: /forward   |
    |   pt-br   | Sitemap: https://pt-br.classpert.com/sitemap.xml.gz | User-agent: *        | Disallow: /forward   |

