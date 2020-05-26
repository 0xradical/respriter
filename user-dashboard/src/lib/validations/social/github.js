import { validate } from "./base";

export const canonicalURL = id => `github.com/${id}`;

export const validator = validate({
  host: {
    pattern: /^(?:www\.)?(?:github\.com)$/
  },
  id: {
    pattern: /^(?!.*(?:\/))[A-z\d](?:[A-z\d]|-(?=[A-z\d])){0,38}$/,
    where: [{ position: 0 }]
  },
  canonicalURL
});
