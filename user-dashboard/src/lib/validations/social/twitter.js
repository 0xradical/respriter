import { validate } from "./base";

export const canonicalURL = id => `twitter.com/${id}`;

export const validator = validate({
  host: {
    pattern: /^(?:www\.)?(?:twitter\.com)$/
  },
  id: {
    pattern: /^(?!.*(?:\/))[A-z\d_]{4,15}$/,
    where: [{ position: 0 }]
  },
  canonicalURL
});
