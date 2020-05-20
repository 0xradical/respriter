# Classpert Bot

Classpert Bot is the name of our web crawler. Since our integration is mostly about consuming your content, it will access your website to validate domains, look for sitemaps, and (for every entry in your sitemap) periodically detect and scrape course data that will be listed on Classpert.

If you use a firewall, anti-bot or throttling service in front of your application, make sure to whitelist our bot.

To do so, whitelist the following User-Agent:

```
ClasspertBot (token: SOME_TOKEN)
```

Where `SOME_TOKEN` is the token that is provided once your domain is validated, on our [Index Tool Dashboard](/dashboard) in the `Website Settings` section, under the field `Privacy Settings -> Crawler Token`.

::: remark-note
This token is unique for your application, so you can use it to hide our metadata from undesired services. The User-Agent header goes along with every request Classpert Bot does.
:::
