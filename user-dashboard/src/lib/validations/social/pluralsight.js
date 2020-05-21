// https://pluralsight.com/authors/alex-ziskind

import { validate } from "./base";

export const canonicalURL = id => `pluralsight.com/authors/${id}`;

export const validator = validate({
  host: {
    pattern: /^(?:www\.)?(?:pluralsight\.com)$/
  },
  id: {
    pattern: /^(?!.*(?:\/))[a-z\d](?:[a-z\d]|-(?=[a-z\d])){4,}$/,
    where: [{ path: /^authors\//, position: 1 }]
  },
  canonicalURL
});
