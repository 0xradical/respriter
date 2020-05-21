import { validate } from "./base";

export const canonicalURL = id => `reddit.com/user/${id}`;

export const validator = validate({
  host: {
    pattern: /^(?:www\.)?(?:reddit\.com)$/
  },
  id: {
    pattern: /^(?!.*(?:\/))(?:[A-z\d\-_]){3,20}$/,
    where: [{ path: /^user\//, position: 1 }]
  },
  canonicalURL
});
