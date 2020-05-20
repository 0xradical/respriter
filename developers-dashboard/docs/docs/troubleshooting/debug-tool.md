# Debug Tool

In order to verify if everything is in check before listing your courses on Classpert, we offer a debug tool on our [Index Tool Dashboard](/dashboard). Just click on the `Debug Tool` link in the navigation bar (at the top) and fill in the path of a course page on your website you want to check for correctness. Classpert Bot will scrape this page and the first thing it will look for is the presence of our [Classpert JSON](/docs/classpert-json-schema.html).

This tool will log any integration error that will occur when our bot crawls a specific course page. Upon successful processing, this tool will render our course UI components, just like they would appear throughout Classpert's website, giving you a preview of how your data will actually show up on Classpert and let you correct any mistake before we crawl and publish your courses.

::: remark-attention
The URL's domain in the debug tool field should match any of your verified domains.
:::

If everything looks good, go ahead and enable the scraping by clicking `Enable Indexing` in the `Indexing Status` section of the domain you just debugged.
