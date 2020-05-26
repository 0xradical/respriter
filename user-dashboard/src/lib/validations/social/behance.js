import { validate } from "./base";

export const canonicalURL = id => `behance.net/${id}`;

export const validator = validate({
  host: {
    pattern: /^(?:www\.)?(?:behance\.net|be\.net)$/
  },
  id: {
    pattern: /^(?!.*(?:\/))(?:[A-z\d\-_]){3,20}$/,
    where: [{ position: 0 }]
  },
  canonicalURL
});
