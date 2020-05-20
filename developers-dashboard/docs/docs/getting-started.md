# Introduction

A core sub-system of Classpert is a crawling engine that we use to fetch online courses on the web, which are then listed on our platform. This engine crawls thousands of courses from several providers periodically. We strive to make this process as abstract and generic as possible, however, we still have to deal with each provider's content specificity which makes the web crawling process difficult to scale. To expand the reach of our services we’ve created a minimal integration interface called Classpert Index Tool to help our crawling bot discover and understand your content so that you, as an instructor or a course platform, can list your courses directly on Classpert, in a timely fashion.

With our pull-based approach, you can rest assured your content is always in-sync with Classpert. No need to worry about submitting new courses, updating or removing obsolete ones. As long as you keep your content (and the associated metadata) updated on your site, we take care of the entire life-cycle of your courses on Classpert.

## How to list your courses using the Classpert Index Tool

### 1. Add our Classpert JSON

Add our Classpert JSON to every course page you want listed on Classpert. Here is an example:

```html
<script type="application/vnd.classpert+json">
  {
    "id": "2",
    "course_name": "Artificial Intelligence 101",
    "url": "https://myprovider.com/mycourses/2",
    "slug": "artificial-intelligence",
    "status": "available",
    "level": "advanced",
    "offered_by": [
      {
        "type": "company",
        "name": "My Provider"
      }
    ],
    "instructors": [
      {
        "name": "Joseph Doe"
      }
    ],
    "free_content": false,
    "paid_content": true,
    "prices": [
      {
        "type": "single_course",
        "price": "200.00",
        "plan_type": "regular",
        "customer_type": "individual",
        "currency": "USD"
      }
    ],
    "description": "This is the description for the Artificial Intelligence course",
    "pace": "self_paced",
    "duration": { "value": 150, "unit": "hours" },
    "language": ["en"],
    "audio": ["en"],
    "subtitles": ["en", "es"],
    "video": {
      "type": "raw",
      "url": "https://myprovider.com/mycourses/2/video.mp4",
      "thumbnail_url": "https://myprovider.com/mycourses/2/preview.jpg"
    }
  }
</script>
```

Read more about Classpert JSON [here](/docs/classpert-json-schema.html).

::: remark-note
The trickiest fields in this JSON are `id` and `url`. Read the corresponding sections carefully at [schema definitions](/docs/classpert-json-schema.html).

They are used to uniquely identify your course and to redirect users to the right page on your site.
:::

::: remark-note
Classpert Bot is the name of the crawler we use to scrape your website.
You can whitelist the bot's access if you wish to hide your metadata for unintended services / audiences. Read the section on Classpert Bot [here](/docs/troubleshooting/classpert-bot.html) to understand how to go about it.
:::

### 2. Test our Classpert JSON

After adding our Classpert JSON to your course page, you can test the validity of the data by using our Debug Tools.

Read more about debugging your Classpert JSON [here](/docs/troubleshooting/debug-tool.html).

### 3. Add a Sitemap

Now that you're confident your course pages are ready to be crawled, add a Sitemap in your dashboard. This is to make sure that crawling bot knows how to navigate your website.

Read more about Sitemap configuration [here](/docs/troubleshooting/sitemap.html).

### 4. Press the start button!

After completing all of the steps above, just click on `Enable indexing` in the `Index Status` section in the [Index Tool Dashboard](https://listing.classpert.com/dashboard) and we will schedule our crawler to fetch the data of your website. We will let you know when your courses get listed on Classpert!

::: remark-note
We assume you have already validated your website domain through our 3-step wizard located in our [Index Tool Dashboard](https://listing.classpert.com/dashboard). If you haven't done this yet, go to [New Domain Wizard](/dashboard/domains/new) and follow the instructions.
:::

## Need help ?

Still need help? You may [contact us](https://classpert.com/contact-us) at any time if you need further assistance.
