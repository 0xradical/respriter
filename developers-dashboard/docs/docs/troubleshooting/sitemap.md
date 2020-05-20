# Sitemap

A sitemap is a list of website's pages. Classpert Bot (our crawler) depends on this sitemap to scrape data off your website and list your courses on Classpert, so you need to provide a sitemap as an XML file served by your website. This provided file may also be a sitemap index XML file (a list of sitemaps, if you have many pages and need to split the files). Please, refer to [this website](https://www.sitemaps.org/protocol.html) for further information on XML sitemaps and their format.

When you start out the [domain validation process](/docs/troubleshooting/domain-validation.html), we first try to detect a sitemap file on your robots.txt file. A valid entry for the Classpert Bot will look like this:

```
User-agent: ClasspertBot
Allow: /

Sitemap: https://YOUR_DOMAIN.com/sitemap.xml
```

::: remark-attention
You may have more than one sitemap entry on your robots.txt file but only the first one will be considered. Therefore, if you have multiple sitemaps, we advise you to use one sitemap index XML file to list them. If for any reason you also have multiple sitemaps indices, you can provide a unique, specific file for Classpert Bot and change it manually on the dashboard, in the `Indexing Status` section).
:::

If no sitemap entry was found on robots.txt, Classpert Bot will try to automatically detect a sitemap file served by your website. The following file names will be looked for:

- /sitemap.xml
- /sitemap.xml.gz
- /sitemap_index.xml
- /sitemap_index.xml.gz

If none of those were found either, then your domain won't have an associated sitemap and Classpert Bot won't be able to scrape your website. You will have to fill in the path to your domain's sitemap file manually or
provide a list of course URLs manually (we accept up to 50 URLs using this method). To do this, go to our [Index Tool Dashboard](/dashboard) and click on the `Indexing Status` section.

::: remark-attention
Although we don't enforce the presence of a sitemap XML file when validating your domain, you won't be able to integrate further if you don't provide one.
If you don't have one, at least provide a manually input list of up to 50 URLs in the `Index Status` section.
:::
