import { validate } from "./base";

export const canonicalURL = id => `teamtreehouse.com/${id}`;

export const validator = validate({
  host: {
    pattern: /^(?:www\.)?(?:teamtreehouse\.com)$/
  },
  id: {
    pattern: /^(?!.*(?:\/))(?:[a-z]{3,30})$/,
    where: [{ position: 0 }]
  },
  canonicalURL
});
