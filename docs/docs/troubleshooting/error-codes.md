# Error Codes

During the integration processing, we might display error codes and accompanying hint messages in the following format:

```
[#XXABCD] Message
```

Error's XX portion refers to the error class and the ABCD portion refers to the specific error within that class. Here's an exhausting table of all possible error codes and brief explanations:

## Crawling Errors

::: el:m-table
| code | description |
| -----|----------|
| **`070001`** | Internal Error. Something wrong happened when Classpert Bot crawled your course's page, due to something you or us did wrong |
| **`070002`** | Page Fetch Error. Could not retrieve a sitemap page, with status codes being 2xx or 3xx |
| **`070003`** | Page Fetch Error. Could not retrieve a course page, with status codes being 2xx or 3xx |
| **`070004`** | Invalid Course Error. Fields in your JSON are not valid |
| **`070005`** | Invalid Course Description. Your course's description field is not a valid Markdown source or has forbidden content like links, images os html tags |
| **`070006`** | Invalid Classpert Metadata Error. You have malformed JSON on your page |
| **`070007`** | Multiple Courses on Page. Right now we don't support pages with more than one course (this could change soon) |
| **`070008`** | Unverified URL domain on course. You pointed to an URL on your course page that is not verified as owned by you |
| **`070009`** | Unverified URL domain on sitemap. You pointed to an URL on your sitemap that is not verified as owned by you |
| **`070010`** | Malformed Sitemap. You pointed an invalid sitemap url that does not contain any page url or other page url. |
:::

## Domain Validation Errors

::: el:m-table
| code | description |
| -----|----------|
| **`100000`** | Domain structure not found on database |
| **`100001`** | Domain's associated user not found on database |
| **`100002`** | Domain already validated |
| **`100003`** | Domain already taken |
| **`100004`** | Domain validation failed temporarily, will try again |
| **`100005`** | Domain validation failed permanently, restart process |
| **`100006`** | Name derived from domain url cannot be used |
| **`100007`** | Name derivation from domain failed |
| **`100008`** | Domain configuration failed |
| **`100009`** | Domain already being validated |
:::

## Sitemap Validation Errors

::: el:m-table
| code | description |
| -----|----------|
| **`110000`** | Sitemap structure not found on database |
| **`110001`** | Sitemap URL returned non-successful status code (response code is not 200) |
| **`110002`** | Sitemap XML file provided is not valid |
| **`110003`** | Sitemap provided is not a well-formed XML file |
| **`110004`** | Sitemap detection failed |
:::

## Debug Tool Errors

::: el:m-table
| code | description |
| -----|----------|
| **`120000`** | Debug structure not found on database |
| **`120001`** | Classpert URI not set |
| **`120002`** | Course page returned non-successful status code (response code is not 200) |
| **`120003`** | Course page doesn't have a vnd.classpert+json structure |
| **`120004`** | Course page's vnd.classpert+json structure is malformed |
| **`120005`** | Course page's vnd.classpert+json is not valid |
| **`120006`** | Debug structure could not be generated |
| **`120007`** | Debug screenshotting failed |
:::
