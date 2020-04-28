INSERT INTO app.datasets (
  id, name, sequence
) VALUES (
  'c1225396-28e1-11ea-9078-0242ac150002', 'Classpert', 999999999
);

INSERT INTO app.users (
  dataset_id, username, password
) VALUES (
  'c1225396-28e1-11ea-9078-0242ac150002', 'user', 'abc123'
);

INSERT INTO app.resource_schemas (
  dataset_id,
  kind,
  schema_version,
  specification,
  public_specification
) VALUES (
  'c1225396-28e1-11ea-9078-0242ac150002',
  'course',
  '1.0.0',
  '
  {
    "$schema": "http://json-schema.org/draft-07/schema#",
    "$id": "https://napoleon.classpert.com/schemas/course/1.0.0",
    "type": "object",
    "definitions": {
      "id": {
        "type": "string",
        "pattern": "^(?!\\s*$).+"
      },
      "status": {
        "type": "string",
        "enum": [
          "available",
          "unavailable",
          "finished",
          "upcoming",
          "coming_soon",
          "in_progress"
        ]
      },
      "offered_by": {
        "type": "object",
        "properties": {
          "type": {
            "type": "string",
            "enum": [
              "university",
              "company",
              "other"
            ]
          },
          "name": {
            "type": "string",
            "pattern": "^(?!\\s*$).+"
          },
          "distinguished": {
            "type": "boolean",
            "default": false
          },
          "main": {
            "type": "boolean",
            "default": true
          }
        }
      },
      "level": {
        "type": "string",
        "enum": [
          "beginner",
          "intermediate",
          "advanced"
        ]
      },
      "instructor": {
        "type": "object",
        "properties": {
          "name": {
            "type": "string",
            "pattern": "^(?!\\s*$).+"
          },
          "distinguished": {
            "type": "boolean",
            "default": false
          },
          "main": {
            "type": "boolean",
            "default": true
          }
        }
      },
      "certificate": {
        "type": "object",
        "properties": {
          "type": {
            "type": "string",
            "enum": [
              "paid",
              "free",
              "included"
            ]
          }
        },
        "required": [
          "type"
        ],
        "if": {
          "properties": {
            "type": {
              "const": "paid"
            }
          }
        },
        "then": {
          "properties": {
            "price": {
              "$ref": "#/definitions/price"
            },
            "currency": {
              "$ref": "#/definitions/currency"
            }
          },
          "required": [
            "price",
            "currency"
          ]
        }
      },
      "customer_type": {
        "type": "string",
        "enum": [
          "individual",
          "enterprise"
        ],
        "default": "individual"
      },
      "plan_type": {
        "type": "string",
        "enum": [
          "regular",
          "premium"
        ],
        "default": "regular"
      },
      "price": {
        "type": "string",
        "pattern": "^[0-9]{1,}(\\.[0-9]{2})?$"
      },
      "percentage": {
        "type": "string",
        "pattern": "^([1-9][0-9]+|[0-9])(\\.[0-9]+)?\\s*\\%$"
      },
      "discount": {
        "anyOf": [
          {
            "$ref": "#/definitions/percentage"
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
            "enum": [
              "minutes",
              "hours",
              "days",
              "weeks",
              "months",
              "years",
              "lessons",
              "chapters"
            ]
          }
        },
        "required": [
          "value",
          "unit"
        ]
      },
      "price_type": {
        "type": "object",
        "properties": {
          "type": {
            "enum": [
              "single_course",
              "subscription"
            ]
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
        "required": [
          "type",
          "price",
          "currency"
        ],
        "allOf": [
          {
            "if": {
              "properties": {
                "discount": {
                  "const": null
                }
              }
            },
            "else": {
              "required": [
                "original_price"
              ]
            }
          },
          {
            "if": {
              "properties": {
                "original_price": {
                  "const": null
                }
              }
            },
            "else": {
              "required": [
                "discount"
              ]
            }
          },
          {
            "if": {
              "properties": {
                "type": {
                  "const": "subscription"
                }
              }
            },
            "then": {
              "properties": {
                "total_price": {
                  "$ref": "#/definitions/price"
                },
                "subscription_period": {
                  "$ref": "#/definitions/period"
                },
                "payment_period": {
                  "$ref": "#/definitions/period"
                },
                "trial_period": {
                  "$ref": "#/definitions/period"
                }
              },
              "required": [
                "total_price",
                "subscription_period",
                "payment_period"
              ]
            }
          }
        ]
      },
      "category": {
        "type": "string",
        "enum": [
          "personal_development",
          "arts_and_design",
          "life_sciences",
          "data_science",
          "health_and_fitness",
          "language_and_communication",
          "physical_science_and_engineering",
          "math_and_logic",
          "marketing",
          "business",
          "social_sciences",
          "computer_science"
        ]
      },
      "tag": {
        "type": "string",
        "pattern": "^[A-Za-z0-9_]+$"
      },
      "rating": {
        "anyOf": [
          {
            "type": "string",
            "pattern": "^([1-9][0-9]+|[0-9])(\\.[0-9]+)?$"
          },
          {
            "type": "object",
            "properties": {
              "type": {
                "enum": [
                  "stars"
                ]
              },
              "value": {
                "type": "number"
              },
              "range": {
                "anyOf": [
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
            "required": [
              "type",
              "value",
              "range"
            ]
          }
        ]
      },
      "language": {
        "type": "string",
        "pattern": "^[a-zA-Z-]{2,}$"
      },
      "video": {
        "type": "object",
        "properties": {
          "type": {
            "enum": [
              "video_service",
              "youtube",
              "vimeo",
              "brightcove",
              "raw",
              "self_hosted",
              "coursera_hosted"
            ]
          }
        },
        "required": [
          "type"
        ],
        "allOf": [
          {
            "if": {
              "properties": {
                "type": {
                  "const": "video_service"
                }
              }
            },
            "then": {
              "properties": {
                "path": {
                  "type": "string"
                }
              },
              "required": [
                "path"
              ]
            }
          },
          {
            "if": {
              "properties": {
                "type": {
                  "enum": [
                    "youtube",
                    "vimeo"
                  ]
                }
              }
            },
            "then": {
              "properties": {
                "id": {
                  "type": "string"
                }
              },
              "required": [
                "id"
              ]
            }
          },
          {
            "if": {
              "properties": {
                "type": {
                  "const": "brightcove"
                }
              }
            },
            "then": {
              "properties": {
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
              "required": [
                "url",
                "embed"
              ]
            }
          },
          {
            "if": {
              "properties": {
                "type": {
                  "const": "raw"
                }
              }
            },
            "then": {
              "properties": {
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
              "required": [
                "url"
              ]
            }
          },
          {
            "if": {
              "properties": {
                "type": {
                  "enum": [
                    "self_hosted",
                    "coursera_hosted"
                  ]
                }
              }
            },
            "then": {
              "properties": {
                "url": {
                  "type": "string",
                  "format": "uri"
                },
                "thumbnail_url": {
                  "type": "string",
                  "format": "uri"
                }
              },
              "required": [
                "url"
              ]
            }
          }
        ]
      }
    },
    "required": [
      "id"
    ],
    "properties": {
      "id": {
        "$ref": "#/definitions/id"
      },
      "status": {
        "$ref": "#/definitions/status",
        "default": "available"
      },
      "slug": {
        "type": "string",
        "pattern": "^[0-9a-zA-Z\\-\\_]+$"
      },
      "course_name": {
        "type": "string",
        "pattern": "^(?!\\s*$).+"
      },
      "level": {
        "anyOf": [
          {
            "$ref": "#/definitions/level"
          },
          {
            "type": "array",
            "minItems": 1,
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
            "type": "string",
            "format": "date-time"
          },
          "ends_at": {
            "type": "string",
            "format": "date-time"
          },
          "valid_until": {
            "type": "string",
            "format": "date-time"
          },
          "duration": {
            "$ref": "#/definitions/period"
          },
          "workload": {
            "$ref": "#/definitions/period"
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
          }
        },
        "required": [
          "start_at"
        ]
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
        "pattern": "^(?!\\s*$).+"
      },
      "syllabus": {
        "type": "string"
      },
      "pace": {
        "type": "string",
        "enum": [
          "instructor_paced",
          "self_paced",
          "live_class"
        ]
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
        "$ref": "#/definitions/rating"
      },
      "language": {
        "type": "array",
        "items": {
          "$ref": "#/definitions/language"
        },
        "minItems": 1
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
        "type": "boolean"
      },
      "stale": {
        "type": "boolean"
      },
      "alternative_course_id": {
        "$ref": "#/definitions/id"
      },
      "extra": {
        "type": "object"
      },
      "json_ld": {
        "type": "array"
      },
      "video": {
        "$ref": "#/definitions/video"
      }
    },
    "allOf": [
      {
        "if": {
          "properties": {
            "paid_content": {
              "const": true
            }
          }
        },
        "then": {
          "properties": {
            "prices": {
              "minItems": 1
            }
          },
          "required": [
            "prices"
          ]
        }
      },
      {
        "if": {
          "properties": {
            "status": {
              "const": "available"
            }
          }
        },
        "then": {
          "required": [
            "course_name",
            "url",
            "free_content",
            "paid_content",
            "description",
            "provider_id",
            "pace",
            "language",
            "subtitles",
            "audio"
          ]
        }
      }
    ]
  }
  ',
  '
  {
    "$schema": "http://json-schema.org/draft-07/schema#",
    "$id": "https://napoleon.classpert.com/schemas/course/1.0.0",
    "type": "object",
    "definitions": {
      "id": {
        "type": "string",
        "pattern": "^(?!\\s*$).+"
      },
      "status": {
        "type": "string",
        "enum": [
          "available",
          "unavailable",
          "finished",
          "upcoming",
          "coming_soon",
          "in_progress"
        ]
      },
      "offered_by": {
        "type": "object",
        "properties": {
          "type": {
            "type": "string",
            "enum": [
              "university",
              "company",
              "other"
            ]
          },
          "name": {
            "type": "string",
            "pattern": "^(?!\\s*$).+"
          },
          "main": {
            "type": "boolean",
            "default": true
          }
        }
      },
      "level": {
        "type": "string",
        "enum": [
          "beginner",
          "intermediate",
          "advanced"
        ]
      },
      "instructor": {
        "type": "object",
        "properties": {
          "name": {
            "type": "string",
            "pattern": "^(?!\\s*$).+"
          },
          "main": {
            "type": "boolean",
            "default": true
          }
        }
      },
      "certificate": {
        "type": "object",
        "properties": {
          "type": {
            "type": "string",
            "enum": [
              "paid",
              "free",
              "included"
            ]
          }
        },
        "required": [
          "type"
        ],
        "if": {
          "properties": {
            "type": {
              "const": "paid"
            }
          }
        },
        "then": {
          "properties": {
            "price": {
              "$ref": "#/definitions/price"
            },
            "currency": {
              "$ref": "#/definitions/currency"
            }
          },
          "required": [
            "price",
            "currency"
          ]
        }
      },
      "customer_type": {
        "type": "string",
        "enum": [
          "individual",
          "enterprise"
        ],
        "default": "individual"
      },
      "plan_type": {
        "type": "string",
        "enum": [
          "regular",
          "premium"
        ],
        "default": "regular"
      },
      "price": {
        "type": "string",
        "pattern": "^[0-9]{1,}(\\.[0-9]{2})?$"
      },
      "percentage": {
        "type": "string",
        "pattern": "^([1-9][0-9]+|[0-9])(\\.[0-9]+)?\\s*\\%$"
      },
      "discount": {
        "anyOf": [
          {
            "$ref": "#/definitions/percentage"
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
            "enum": [
              "minutes",
              "hours",
              "days",
              "weeks",
              "months",
              "years",
              "lessons",
              "chapters"
            ]
          }
        },
        "required": [
          "value",
          "unit"
        ]
      },
      "price_type": {
        "type": "object",
        "properties": {
          "type": {
            "enum": [
              "single_course",
              "subscription"
            ]
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
        "required": [
          "type",
          "price",
          "currency"
        ],
        "allOf": [
          {
            "if": {
              "properties": {
                "discount": {
                  "const": null
                }
              }
            },
            "else": {
              "required": [
                "original_price"
              ]
            }
          },
          {
            "if": {
              "properties": {
                "original_price": {
                  "const": null
                }
              }
            },
            "else": {
              "required": [
                "discount"
              ]
            }
          },
          {
            "if": {
              "properties": {
                "type": {
                  "const": "subscription"
                }
              }
            },
            "then": {
              "properties": {
                "total_price": {
                  "$ref": "#/definitions/price"
                },
                "subscription_period": {
                  "$ref": "#/definitions/period"
                },
                "payment_period": {
                  "$ref": "#/definitions/period"
                },
                "trial_period": {
                  "$ref": "#/definitions/period"
                }
              },
              "required": [
                "total_price",
                "subscription_period",
                "payment_period"
              ]
            }
          }
        ]
      },
      "category": {
        "type": "string",
        "enum": [
          "personal_development",
          "arts_and_design",
          "life_sciences",
          "data_science",
          "health_and_fitness",
          "language_and_communication",
          "physical_science_and_engineering",
          "math_and_logic",
          "marketing",
          "business",
          "social_sciences",
          "computer_science"
        ]
      },
      "tag": {
        "type": "string",
        "pattern": "^[A-Za-z0-9_]+$"
      },
      "language": {
        "type": "string",
        "pattern": "^[a-zA-Z-]{2,}$"
      },
      "video": {
        "type": "object",
        "properties": {
          "type": {
            "enum": [
              "youtube",
              "vimeo",
              "brightcove",
              "raw"
            ]
          }
        },
        "required": [
          "type"
        ],
        "allOf": [
          {
            "if": {
              "properties": {
                "type": {
                  "enum": [
                    "youtube",
                    "vimeo"
                  ]
                }
              }
            },
            "then": {
              "properties": {
                "id": {
                  "type": "string"
                }
              },
              "required": [
                "id"
              ]
            }
          },
          {
            "if": {
              "properties": {
                "type": {
                  "const": "brightcove"
                }
              }
            },
            "then": {
              "properties": {
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
              "required": [
                "url",
                "embed"
              ]
            }
          },
          {
            "if": {
              "properties": {
                "type": {
                  "const": "raw"
                }
              }
            },
            "then": {
              "properties": {
                "url": {
                  "type": "string",
                  "format": "uri"
                },
                "thumbnail_url": {
                  "type": "string",
                  "format": "uri"
                }
              },
              "required": [
                "url"
              ]
            }
          }
        ]
      }
    },
    "required": [
      "id"
    ],
    "properties": {
      "id": {
        "$ref": "#/definitions/id"
      },
      "status": {
        "$ref": "#/definitions/status",
        "default": "available"
      },
      "slug": {
        "type": "string",
        "pattern": "^[0-9a-zA-Z\\-\\_]+$"
      },
      "course_name": {
        "type": "string",
        "pattern": "^(?!\\s*$).+"
      },
      "level": {
        "anyOf": [
          {
            "$ref": "#/definitions/level"
          },
          {
            "type": "array",
            "minItems": 1,
            "items": {
              "$ref": "#/definitions/level"
            }
          }
        ]
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
            "type": "string",
            "format": "date-time"
          },
          "ends_at": {
            "type": "string",
            "format": "date-time"
          },
          "valid_until": {
            "type": "string",
            "format": "date-time"
          },
          "duration": {
            "$ref": "#/definitions/period"
          },
          "workload": {
            "$ref": "#/definitions/period"
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
          }
        },
        "required": [
          "start_at"
        ]
      },
      "certificate": {
        "$ref": "#/definitions/certificate"
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
      "description": {
        "type": "string",
        "pattern": "^(?!\\s*$).+"
      },
      "pace": {
        "type": "string",
        "enum": [
          "instructor_paced",
          "self_paced",
          "live_class"
        ]
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
      "language": {
        "type": "array",
        "items": {
          "$ref": "#/definitions/language"
        },
        "minItems": 1
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
      "stale": {
        "type": "boolean"
      },
      "alternative_course_id": {
        "$ref": "#/definitions/id"
      },
      "video": {
        "$ref": "#/definitions/video"
      }
    },
    "allOf": [
      {
        "if": {
          "properties": {
            "paid_content": {
              "const": true
            }
          }
        },
        "then": {
          "properties": {
            "prices": {
              "minItems": 1
            }
          },
          "required": [
            "prices"
          ]
        }
      },
      {
        "if": {
          "properties": {
            "status": {
              "const": "available"
            }
          }
        },
        "then": {
          "required": [
            "course_name",
            "url",
            "free_content",
            "paid_content",
            "description",
            "pace",
            "language",
            "subtitles",
            "audio"
          ]
        }
      }
    ]
  }
  '
);