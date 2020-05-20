# Domain Validation

Our 3-step wizard guides you in the process of validating the ownership of your domain. This process is important as it guarantees that you are a legitimate domain's administrator.

On step 1, fill in your domain without protocol (for example, if you were Google.com's owner, just type `google.com` instead of `https://google.com`). At this moment, we will only allow domains that are not already taken. If you need access a domain that has been already taken, please [contact us](https://classpert.com/contact-us).

On step 2, we provide instructions to prove that you have ownership of your domain, all of which are based on a validation token unique to each user. There are 3 ways you can prove it:

1. You can add a CNAME entry to your domain's DNS entries
2. You can add a TXT entry to your domain's DNS entries
3. You can add an HTML meta header on your website's homepage

If you choose to validate your domain via DNS using either option 1) or 2), be careful that DNS entries may not be readily available. DNS updates take some time to propagate, therefore do not remove the entries in case of detection failure as we will retry to validate your domain several times.

::: remark-note
Subdomains you wish to validate in the future will be automatically validated if the main domain was validated via DNS.
:::

If you choose to validate your domain via HTML, your token should be present on the website's homepage in a meta header. Our bot will check the homepage for the token so your website should already allow our bot to scrape it. We also provide a unique user-agent string along with each request to identify the bot if you have a bot filter system in place and need to whitelist it. Check [this section](/docs/troubleshooting/classpert-bot.html) for more on our bot.

::: remark-attention
Subdomains you wish to validate in the future won't be automatically validated if you choose the HTML validation method
:::

If the validation process succeeds, the following additional setups will take place:

1. We will generate and assign your domain with a name that will be used to identify your content across Classpert's pages. This name will be automatically generated based on your domain's URL (for example, `subdomain.classpert.com` would generate the name `Subdomain`). If you need to change this name, please [contact us](https://classpert.com/contact-us). If for some reason your name can't be used, the validation process will stop immediately and we will have to take over manually on our side.

2. We will try to detect a sitemap associated with your domain. Our bot will first try to detect a sitemap entry on your robots.txt file. If there is no entry, then the bot will look for the following files:

- /sitemap.xml
- /sitemap.xml.gz
- /sitemap_index.xml
- /sitemap_index.xml.gz

If there's no sitemap to be found, you will need to provide one. For more on sitemaps, read the [sitemap](/docs/troubleshooting/sitemap.html) section.
