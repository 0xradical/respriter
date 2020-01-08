INSERT INTO app.datasets (
  id,
  name
) VALUES (
  'c1225396-28e1-11ea-9078-0242ac150002',
  'Classpert'
);

INSERT INTO app.users (
  dataset_id,
  email,
  password
) VALUES (
  'c1225396-28e1-11ea-9078-0242ac150002',
  'user@classpert.com',
  'abc123'
);

INSERT INTO app.resource_schemas (
  dataset_id,
  kind,
  schema_version,
  specification
) VALUES (
  'c1225396-28e1-11ea-9078-0242ac150002',
  'course',
  '0.0.1',
  '{
    "$schema": "http://json-schema.org/draft-07/schema#",
    "$id": "https://napoleon.classpert.com/schemas/course/0.0.1",
    "type": "object",
    "definitions": {
      "uuid": {
        "type": "string",
        "pattern": "^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$"
      },
      "status": {
        "type": "string",
        "enum": ["available", "unavailable", "finished", "upcoming", "coming_soon", "in_progress"]
      },
      "offered_by": {
        "type": "object",
        "properties": {
          "type": {
            "type": "string",
            "enum": ["university", "company", "other"]
          },
          "name": {
            "type": "string"
          },
          "distinguished": {
            "type": "boolean",
            "default": "false"
          },
          "main": {
            "type": "boolean",
            "default": "true"
          }
        }
      },
      "datetime": {
        "type": "string",
        "pattern": "^[0-9]{1,2}\\[0-9]{1,2}\\[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}$"
      },
      "level": {
        "type": "string",
        "enum": ["beginner", "intermediate", "advanced"]
      },
      "instructor": {
        "type": "object",
        "properties": {
          "name": {
            "type": "string"
          },
          "distinguished": {
            "type": "boolean",
            "default": "false"
          },
          "main": {
            "type": "boolean",
            "default": "true"
          }
        }
      },
      "certificate": {
        "type": "object",
        "oneOf": [
          {
            "properties": {
              "type": {
                "type": "string",
                "enum": ["free", "included"]
              }
            }
          },
          {
            "properties": {
              "type": {
                "enum": ["paid"]
              },
              "price": {
                "$ref": "#/definitions/price"
              },
              "currency": {
                "$ref": "#/definitions/currency"
              }
            },
            "required": ["type", "price", "currency"]
          }
        ]
      },
      "customer_type": {
        "type": "string",
        "enum": ["individual", "enterprise"],
        "default": "individual"
      },
      "plan_type": {
        "type": "string",
        "enum": ["regular", "premium"],
        "default": "regular"
      },
      "price": {
        "type": "string",
        "pattern": "^[0-9]{1,}(\\.[0-9]{2})?$"
      },
      "discount": {
        "oneOf": [
          {
            "type": "string",
            "pattern": "^([1-9][0-9]+|[0-9])(\\.[0-9]+)?\\s*\\%$"
          },
          {
            "$ref": "#/definitions/price"
          }
        ]
      },
      "currency": {
        "type": "string",
        "pattern": "^[A-Z]{3}$"
      },
      "period": {
        "type": "object",
        "properties": {
          "value": {
            "type": "integer"
          },
          "unit": {
            "type": "string",
            "enum": ["minutes", "hours", "days", "weeks", "months", "years", "lessons", "chapters"]
          }
        }
      },
      "price_type": {
        "type": "object",
        "oneOf": [
          {
            "properties": {
              "type": {
                "enum": ["single_course"]
              },
              "customer_type": {
                "$ref": "#/definitions/customer_type"
              },
              "plan_type": {
                "$ref": "#/definitions/plan_type"
              },
              "price": {
                "$ref": "#/definitions/price"
              },
              "original_price": {
                "$ref": "#/definitions/price"
              },
              "discount": {
                "$ref": "#/definitions/discount"
              },
              "currency": {
                "$ref": "#/definitions/currency"
              },
              "enrollment_ids": {
                "type": "array",
                "items": {
                  "type": "string"
                }
              }
            },
            "required": ["type", "price", "plan_type", "currency"]
          },
          {
            "properties": {
              "type": {
                "enum": ["subscription"]
              },
              "customer_type": {
                "$ref": "#/definitions/customer_type"
              },
              "plan_type": {
                "$ref": "#/definitions/plan_type"
              },
              "price": {
                "$ref": "#/definitions/price"
              },
              "total_price": {
                "$ref": "#/definitions/price"
              },
              "original_price": {
                "$ref": "#/definitions/price"
              },
              "discount": {
                "$ref": "#/definitions/discount"
              },
              "currency": {
                "$ref": "#/definitions/currency"
              },
              "subscription_period": {
                "$ref": "#/definitions/period"
              },
              "payment_period": {
                "$ref": "#/definitions/period"
              },
              "trial_period": {
                "oneOf": [
                  { "type": "null" },
                  { "$ref": "#/definitions/period" }
                ]
              },
              "enrollment_ids": {
                "type": "array",
                "items": {
                  "type": "string"
                }
              }
            },
            "required": ["type", "price", "customer_type", "plan_type", "total_price", "currency", "subscription_period"]
          }
        ]
      },
      "category": {
        "type": "string",
        "enum": ["personal_development", "arts_and_design", "life_sciences", "data_science", "health_and_fitness", "language_and_communication", "physical_science_and_engineering", "math_and_logic", "marketing", "business", "social_sciences", "computer_science"]
      },
      "tag": {
        "type": "string",
        "pattern": "^[A-Za-z0-9_]+$"
      },
      "rating": {
        "type": "object",
        "properties": {
          "type": {
            "enum": ["stars"]
          },
          "value": {
            "type": "number"
          },
          "range": {
            "oneOf": [
              {
                "type": "array",
                "minItems": 2,
                "maxItems": 2,
                "items": {
                  "type": "number"
                }
              },
              {
                "type": "number"
              }
            ]
          }
        },
        "required": ["type", "value", "range"]
      },
      "language": {
        "type": "string",
        "pattern": "^[a-zA-Z-]{2,}$"
      },
      "video": {
        "type": "object",
        "oneOf": [
          {
            "properties": {
              "type": {
                "type": "string",
                "enum": ["video_service"]
              },
              "path": {
                "type": "string"
              }
            },
            "required": [ "type", "path" ]
          },
          {
            "properties": {
              "type": {
                "type": "string",
                "enum": ["youtube", "vimeo"]
              },
              "id": {
                "type": "string"
              }
            },
            "required": [ "type", "id" ]
          },
          {
            "properties": {
              "type": {
                "type": "string",
                "enum": ["brightcove"]
              },
              "url": {
                "type": "string",
                "format": "uri"
              },
              "embed": {
                "type": "boolean"
              },
              "thumbnail_url": {
                "type": "string",
                "format": "uri"
              }
            },
            "required": [ "type", "url", "embed" ]
          },
          {
            "properties": {
              "type": {
                "type": "string",
                "enum": ["raw"]
              },
              "url": {
                "type": "string",
                "format": "uri"
              },
              "thumbnail_url": {
                "type": "string",
                "format": "uri"
              },
              "provider": {
                "type": "string"
              }
            },
            "required": [ "type", "url" ]
          },
          {
            "properties": {
              "type": {
                "type": "string",
                "enum": ["self_hosted", "coursera_hosted"]
              },
              "url": {
                "type": "string",
                "format": "uri"
              }
            },
            "required": [ "type", "url" ]
          }
        ]
      }
    },
    "required": [
      "unique_id",
      "course_name",
      "url",
      "free_content",
      "paid_content",
      "description",
      "pace",
      "language",
      "subtitles",
      "audio"
    ],
    "properties": {
      "unique_id": {
        "type": "string"
      },
      "status": {
        "$ref": "#/definitions/status",
        "default": "available"
      },
      "slug": {
        "type": "string"
      },
      "course_name": {
        "type": "string"
      },
      "level": {
        "oneOf": [
          { "$ref": "#/definitions/level" },
          {
            "type": "array",
            "minItems": 0,
            "items": {
              "$ref": "#/definitions/level"
            }
          }
        ]
      },
      "provider_id": {
        "type": "number"
      },
      "offered_by": {
        "type": "array",
        "items": {
          "$ref": "#/definitions/offered_by"
        }
      },
      "instructors": {
        "type": "array",
        "items": {
          "$ref": "#/definitions/instructor"
        }
      },
      "url": {
        "type": "string",
        "format": "uri"
      },
      "prices": {
        "type": "array",
        "items": {
          "$ref": "#/definitions/price_type"
        }
      },
      "enrollments": {
        "type": "object",
        "properties": {
          "id": {
            "type": "string"
          },
          "starts_at": {
            "oneOf": [
              { "$ref": "#/definitions/datetime" },
              { "type": "null" }
            ]
          },
          "ends_at": {
            "oneOf": [
              { "$ref": "#/definitions/datetime" },
              { "type": "null" }
            ]
          },
          "valid_until": {
            "oneOf": [
              { "$ref": "#/definitions/datetime" },
              { "type": "null" }
            ]
          },
          "url": {
            "type": "string"
          },
          "duration": {
            "oneOf": [
              { "$ref": "#/definitions/period" },
              { "type": "null" }
            ]
          },
          "workload": {
            "oneOf": [
              { "$ref": "#/definitions/period" },
              { "type": "null" }
            ]
          },
          "prices": {
            "type": "array",
            "items": {
              "$ref": "#/definitions/price_type"
            }
          }
        },
        "required": ["start_at"]
      },
      "certificate": {
        "$ref": "#/definitions/certificate"
      },
      "extra_content": {
        "type": "string"
      },
      "free_content": {
        "type": "boolean"
      },
      "paid_content": {
        "type": "boolean"
      },
      "category": {
        "$ref": "#/definitions/category"
      },
      "tags": {
        "type": "array",
        "items": {
          "$ref": "#/definitions/tag"
        }
      },
      "provided_tags": {
        "type": "array",
        "items": {
          "type": "string"
        }
      },
      "provided_categories": {
        "type": "array",
        "items": {
          "type": "string"
        }
      },
      "description": {
        "type": "string",
        "minLength": 100
      },
      "syllabus": {
        "type": "string"
      },
      "pace": {
        "type": "string",
        "enum": ["instructor_paced", "self_paced", "live_class"]
      },
      "duration": {
        "$ref": "#/definitions/period"
      },
      "workload": {
        "$ref": "#/definitions/period"
      },
      "effort": {
        "type": "number"
      },
      "rating": {
        "oneOf": [
          { "$ref": "#/definitions/rating" },
          { "type": "string", "pattern": "^([1-9][0-9]+|[0-9])(\\.[0-9]+)?$" }
        ]
      },
      "language": {
        "type": "array",
        "items": {
          "$ref": "#/definitions/language"
        }
      },
      "subtitles": {
        "type": "array",
        "items": {
          "$ref": "#/definitions/language"
        }
      },
      "audio": {
        "type": "array",
        "items": {
          "$ref": "#/definitions/language"
        }
      },
      "published": {
        "type": "boolean"
      },
      "reviewed": {
        "type": "boolean",
        "default": false
      },
      "stale": {
        "type": "boolean",
        "default": false
      },
      "alternative_course_id": {
        "$ref": "#/definitions/uuid"
      },
      "extra": {
        "type": "object"
      },
      "json_ld": {
        "type": "object"
      },
      "video": {
        "$ref": "#/definitions/video"
      }
    },
    "if": {
      "properties": { "paid_content": { "const": true } }
    },
    "then": {
      "properties": { "prices": { "minItems": 1 } },
      "required": ["prices"]
    }
  }'
);
