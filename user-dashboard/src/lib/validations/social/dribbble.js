import { validate } from "./base";

export const canonicalURL = id => `dribbble.com/${id}`;

export const validator = validate({
  host: {
    pattern: /^(?:www\.)?(?:dribbble\.com)$/
  },
  id: {
    pattern: /^(?!.*(?:\/))(?:[A-z\d\-_]){2,20}$/,
    where: [{ position: 0 }]
  },
  canonicalURL
});
