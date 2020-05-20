# Classpert JSON schema

Each course page on your website must contain a well-formed JSON representation of your course data that Classpert Bot understands.
This JSON structure, referred to as Classpert JSON, must match the following schema:

[https://napoleon.classpert.com/schemas/course/1.0.0](https://napoleon.classpert.com/schemas/course/1.0.0)

## Classpert Tag

When Classpert Bot is scraping a page on your website, it first tries to detect the presence of a Classpert JSON in that page.

This detection will only be successful if there's a script tag with type `application/vnd.classpert+json` containing the Classpert JSON.

## Classpert JSON Example

Here's an example of a minimal Classpert JSON:

```html
<script type="application/vnd.classpert+json">
  {
    "~~id~~": "2",
    "~~course_name~~": "Artificial Intelligence 101",
    "~~url~~": "https://myprovider.com/mycourses/2",
    "~~slug~~": "artificial-intelligence",
    "~~status~~": "available",
    "~~level~~": "advanced",
    "~~offered_by~~": [
      {
        "type": "company",
        "name": "My Provider"
      }
    ],
    "~~instructors~~": [
      {
        "name": "Joseph Doe"
      }
    ],
    "~~free_content~~": false,
    "~~paid_content~~": true,
    "~~prices~~": [
      {
        "type": "single_course",
        "price": "200.00",
        "plan_type": "regular",
        "customer_type": "individual",
        "currency": "USD"
      }
    ],
    "~~description~~": "This is the description for the Artificial Intelligence course",
    "~~pace~~": "self_paced",
    "~~duration~~": { "value": 150, "unit": "hours" },
    "~~language~~": ["en"],
    "~~audio~~": ["en"],
    "~~subtitles~~": ["en", "es"],
    "~~video~~": {
      "type": "self_hosted",
      "url": "https://myprovider.com/mycourses/2/video.mp4",
      "thumbnail_url": "https://myprovider.com/mycourses/2/preview.jpg"
    }
  }
</script>
```

::: remark-note
Add an appropriate `charset` to your HTML to avoid encoding issues. Read more about HTML encodings [here](https://www.w3.org/International/questions/qa-html-encoding-declarations).
:::

## Schema Properties

A schema property is simply a key in a Classpert JSON.

::: remark-note
The Classpert JSON is structured as a list of schema properties whose types may be normal, primitive JSON types (like `string` or `integer`) or complex, custom types (like `instructor`). These custom types allow for a more terse structuring. They are described in the [Schema Definitions](#schema-definitions) section.
:::

::: schema-property

### id

- **type**: `string`
- **required**: `true`

This is the unique identification of your course, on your side.

We will use this property to uniquely identify your course, not page url, so we can keep track of updates of your course even if its URL changes.

This id is usually your database primary key or any other unique value that identifies your course.

If you don't have access to those kind of ids (which is very unlikely), you can use the url of your course's page. Nevertheless, try to avoid using distinct urls for the same course, this will duplicate your course on Classpert.

Remember to cast your id to string if its type is numeric or any other non-string format.

```coffeescript
{
  # ...
  id: "2"
  # ...
}
```

:::

::: schema-property

### course_name

- **type**: `string`
- **required**: `true`

The name of your course

```coffeescript
{
  # ...
  course_name: "Artificial Intelligence 101"
  # ...
}
```

:::

::: schema-property

### slug

- **type**: `string`
- **format**: `[a-zA-Z0-9\-\_]+`
- **required**: `false`

This slug could be used if you want to edit the slug used on Classpert's course page URL.

We always add a digest at the end to avoid duplicates.

A slug will be created automatically if none is provided.

```coffeescript
{
  # ...
  slug: "artificial-intelligence-101"
  # ...
}
```

:::

::: schema-property

### status

- **type**: `string`
- **required**: `true`
- **format**: `"available" | "unavailable" | "finished" | "upcoming" | "coming_soon" | "in_progress"`
- **default**: `"available"`

This is the availability status of your course. Suitable if you wish to have a more fine-grained control of the status of your course.

- `"available"`: Course is available for enrollment so users can start from beginning (this status should be used for self-paced courses)
- `"unavailable"`: Course is unavailable for enrollment
- `"finished"`: Course was available for a moment but enrollment period has ended
- `"upcoming"`: Course will be available for enrollment in the near future, but not scheduled yet
- `"coming_soon"`: Course will be available for enrollment in the near future, and has a date scheduled for it
- `"in_progress"`: Course has already started but it is still available for enrollment

```coffeescript
{
  # ...
  status: "unavailable"
  # ...
}
```

:::

::: schema-property

### level

- **type**: `string`
- **required**: `false`
- **format**: `"beginner" | "intermediate" | "advanced"`

Difficulty level of course

:::

::: schema-property

### offered_by

- **type**: [`array<offered_by>`](#offered-by-2)
- **required**: `false`
- **default**: `[]`

List of individuals, companies, institutions that offer this course.
Most of the time, you will probably use a list of a single entry
with your company name in it, like this:

```coffeescript
{
  offered_by: [
    {
      type: "company",
      name: "My OnLine Courses Platform Co."
    }
  ]
}
```

::: remark-note
The `name` field in an `offered_by` entry is not the same `name` that will show up
on Classpert as the name of your platform. The `name` of your platform is editable
in the `Website Settings` section in the Index Tool.
:::

::: schema-property

### instructors

- **type**: [`array<instructor>`](#instructor)
- **required**: `false`
- **default**: `[]`

List of course instructors

```coffeescript
{
  # ...
  instructors: [
    {
      name: "Joseph Doe"
    }
  ]
  # ...
}
```

:::

::: schema-property

### url

- **type**: `URI`
- **required**: `false`

Course's canonical URL on your website.

This property can be used to tell distinct pages apart (e.g. mobile and desktop urls to same course).

If this property is not set, we will use the URL that is provided on your sitemap.

If you accidentally duplicate an entry on your sitemap, we can't determine which URL will be used. For this reason, this property is not required, but its use is highly recommended.

```coffeescript
{
  # ...
  url: "https://mycourseprovider.com/courses/2"
  # ...
}
```

:::

::: schema-property

### prices

- **type**: [`array<price_type>`](#price-type)
- **required**: `true for courses with paid content`

List of pricing models for the given course. When required, must have at least one pricing model inside the given array.

You may offer multiple currencies, multiple pricing models
for the same course (for example, subscription based or single payment at the same time).

:::

::: schema-property

### certificate

- **type**: [`certificate`](#certificate-2)
- **required**: `false`

:::

::: schema-property

### free_content

Set this to true if course material has at least some free content that could be experienced during the entire course without paying nothing.

Example: Set true if watching all videos are free but exercises and exams are not.

- **type**: `boolean`
- **required**: `true`

:::

::: schema-property

### paid_content

Set this to true if course material has at least some paid content that is required to finish the course.

Example: Even though course has some free content, some videos or classes requires payment.

- **type**: `boolean`
- **required**: `true`

:::

::: schema-property

### description

Description of your course. Be as thorough as you can because this will be used on Classpert's course page, having great impact both content-wise and SEO-wise.

Format its content as [Markdown](https://en.wikipedia.org/wiki/Markdown).

- **type**: `string`
- **required**: `true`

:::

::: schema-property

### pace

Pace at which the course is run.

- **type**: `string`
- **required**: `true`
- **format**: `"instructor_paced" | "self_paced" | "live_class"`

- `"instructor_paced"`: If pace is dictated by the instructor (e.g. content is relasead weekly and learner needs to finish assignments on each week).
- `"self_paced"`: If pace is dictated by the learner (e.g. learner can follow the course starting and finishing everything in its own timing).
- `"live_class"`: If pace is dictated by time (e.g. learner can follow live videos released and scheduled by instructor).

:::

::: schema-property

### duration

Recommended duration to finish the course.

Example: A course could have 4 weeks as duration, having total effort of 20 hours if it has a recommended workload of 5 hours (a week, in this case duration's unit).

- **type**: [`period`](#period)
- **required**: `false`

:::

::: schema-property

### workload

How many units of work per duration's period.

Example: A course could have 4 weeks as duration, having total effort of 20 hours if it has a recommended workload of 5 hours (a week, in this case duration's unit).

- **type**: [`period`](#period)
- **required**: `false`

:::

::: schema-property

### effort

Total hours of effort to finish the course.

Example: A course could have 4 weeks as duration, having total effort of 20 hours if it has a recommended workload of 5 hours (a week, in this case duration's unit).

- **type**: `number`
- **required**: `false`

:::

::: schema-property

### language

- **type**: [`array<language>`](#language-2)
- **required**: `true`

List of main languages provided, must have at least one language defined in this array.

Each item must be formatted as ISO 639-1 with an optional 2-letter country suffix separated by a dash.

:::

::: schema-property

### subtitles

Subtitles language of the course's videos, if there's any (could be an empty array if no subtitles are provided).

Each item must be formatted as ISO 639-1 with an optional 2-letter country suffix separated by a dash.

- **type**: [`array<language>`](#language-2)
- **required**: `true`

:::

::: schema-property

### audio

Audio language of the videos (could be an empty array if course has only written content).

- **type**: [`array<language>`](#language-2)
- **default**: `true`

:::

::: schema-property

### video

Course's video.

- **type**: [`video`](#video-2)
- **default**: `false`

:::

## Schema Definitions

A schema definition is a custom complex type that is composed of simpler, primitive types in a JSON schema. Classpert JSON schema uses the following definitions:

::: schema-definition

### offered_by

- **type**: `object`
- **format**:

```coffeescript
{
  type: {
    type: "string",
    enum: ["university", "company", "other"]
  },
  name: {
    type: "string"
  }
}
```

Example:

```coffeescript
{
  type: "company",
  name: "My OnLine Courses Platform Co."
}
```

:::

::: schema-definition

### instructor

- **type**: `object`
- **format**:

```coffeescript
{
  name: {
    type: "string"
  }
}
```

Example:

```coffeescript
{
  name: "Joseph Doe"
}
```

:::

::: schema-definition

### price_type

- **type**: `object`
- **format**:

```coffeescript
{
  type: {
    type: "enum",
    enum: ["single_course", "subscription"],
    required: true
  },
  customer_type: {
    type: "@@customer_type@@",
    default: "individual"
  },
  plan_type: {
    type: "@@plan_type@@",
    default: "regular"
  },
  price: {
    type: "@@price@@",
    required: true
  },
  original_price: {
    type: "@@price@@",
    required: `IF discount IS NOT NULL`
  },
  discount: {
    type: "@@discount@@",
    required: `IF original_price IS NOT NULL`
  },
  currency: {
    type: "@@currency@@",
    required: true
  },
  total_price: {
    type: "@@price@@",
    required: `IF type == "subscription"`
  },
  subscription_period: {
    type: "@@period@@",
    required: `IF type == "subscription"`
  },
  payment_period: {
    type: "@@period@@",
    required: `IF type == "subscription"`
  },
  trial_period: {
    type: "@@period@@",
    required: `IF type == "subscription"`
  }
}
```

Examples:

```coffeescript
# a single-course (one-time only) based pricing,
# targeted to individuals,
# for a regular tier
# costing 29.99 USD
{
  type: "single_course",
  customer_type: "individual",
  plan_type: "regular",
  price: "29.99",
  currency: "USD"
}

# a subscription based pricing,
# targeted to companies,
# for a premium tier
# costing 199.99 USD / month
# if paid anually
# with a trial of 30 days
{
  type: "subscription",
  customer_type: "enterprise",
  plan_type: "premium",
  price: "16.67",
  total_price: "199.99",
  currency: "USD",
  subscription_period: { value: 12, unit: "months" },
  trial_period: { value: 30, unit: "days" },
  payment_period: { value: 1, unit: "years" }
}
```

:::

::: schema-definition

### price

- **type**: `string`
- **format**: `/^[0-9]{1,}(\\.[0-9]{2})?$/`

Example:

```coffeescript
"20.50"
```

:::

::: schema-definition

### currency

- **type**: `string`
- **format**: [`ISO 4217`](https://en.wikipedia.org/wiki/ISO_4217)

Example:

```coffeescript
"USD"
```

:::

::: schema-definition

### percentage

- **type**: `string`
- **format**: number followed by percentage sign

Example:

```coffeescript
"10.5 %"
```

:::

::: schema-definition

### discount

- **type**: [`price`](#price) | [`percentage`](#percentage)

:::

::: schema-definition

### period

- **type**: `object`
- **format**:

```coffeescript
{
  value: {
    type: "integer",
    required: true
  },
  unit: {
    type: "string",
    enum: [
      "minutes",
      "hours",
      "days",
      "weeks",
      "months",
      "years",
      "lessons",
      "chapters"
    ],
    required: true
  }
}
```

Examples:

```coffeescript
# 2 months
{
  value: 2,
  unit: "months"
}

# 1 chapter
{
  value: 1,
  unit: "chapters"
}
```

:::

::: schema-definition

### certificate

- **type**: `object`
- **format**:

```coffeescript
{
  type: {
    type: "string",
    enum: ["paid", "free", "included"],
    required: true
  },
  price: {
    type: "@@price@@",
    required: `IF type == "paid"`
  },
  currency: {
    type: "@@currency@@",
    required: `IF type == "paid"`
  }
}
```

Examples:

```coffeescript
# certificate is free
{
  type: "free"
}

# certificate is paid and costs 59.99 USD
{
  type: "paid",
  price: "59.99",
  currency: "USD"
}
```

:::

::: schema-definition

### customer_type

- **type**: `string`
- **format**: `"individual" | "enterprise"`
- **default**: `"individual"`

:::

::: schema-definition

### plan_type

- **type**: `string`
- **format**: `"regular" | "premium"`
- **default**: `"regular"`

:::

::: schema-definition

### language

- **type**: `string`
- **format**: [ISO 639-1](https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes) + optional 2-letter country suffix separated by a dash

Examples:

```coffeescript
# Brazilian Portuguese
"pt-BR"

# English
"en"

# American English
"en-US"
```

:::

::: schema-definition

### video

- **type**: `object`
- **format**:

```coffeescript
{
  type: {
    type: "string",
    enum: [
      "youtube",
      "vimeo",
      "raw",
    ],
    required: true
  },
  path: {
    type: "string",
    required: `IF type == "video_service"`
  },
  id: {
    type: "string",
    required: `IF type IN [ "youtube", "vimeo" ]`
  },
  url: {
    type: "uri",
    required: `IF type == "raw"`
  },
  thumbnail_url: {
    type: "uri",
    required: `IF type == "raw"`
  }
}
```

Examples:

```coffeescript
# https://www.youtube.com/watch?v=p6_Uim8OXvQ
{
  type: "youtube",
  id: "p6_Uim8OXvQ"
}

# raw videos
{
  type: "raw",
  url: "https://myprovider.com/courses/2/video.mp4",
  thumbnail_url: "https://aws.myprovider.com/thumbnails/2.png"
}
```

:::
