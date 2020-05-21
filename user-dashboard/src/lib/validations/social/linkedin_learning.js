// https://www.linkedin.com/learning/instructors/joey-d-antoni

import { validate } from "./base";

export const canonicalURL = id => `linkedin.com/learning/instructors/${id}`;

export const validator = validate({
  host: {
    pattern: /^(?:www\.)?(?:linkedin\.com)$/
  },
  id: {
    pattern: /^(?!.*(?:\/))[a-z\d](?:[a-z\d]|-(?=[a-z\d])){2,}$/,
    where: [{ path: /^learning\/instructors\//, position: 2 }]
  },
  canonicalURL
});
