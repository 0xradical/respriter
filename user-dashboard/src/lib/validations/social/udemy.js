// https://www.udemy.com/user/___/
// https://www.udemy.com/user/0a577586-abe2-42d9-a749-8303e62b1d66/

import { validate } from "./base";

export const canonicalURL = id => `udemy.com/user/${id}`;

export const validator = validate({
  host: {
    pattern: /^(?:www\.)?(?:udemy\.com)$/
  },
  id: {
    pattern: /^(?!.*(?:\/))[a-z\d\-_]{3,60}$/,
    where: [{ path: /^user\//, position: 1 }]
  },
  canonicalURL
});
