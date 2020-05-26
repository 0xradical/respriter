import { validate } from "./base";

export const canonicalURL = id => `masterclass.com/classes/${id}`;

export const validator = validate({
  host: {
    pattern: /^(?:www\.)?(?:masterclass\.com)$/
  },
  id: {
    pattern: /^(?!.*(?:\/))(?:[a-z\d](?:[a-z\d]|-(?=[a-z\d])){9,})$/,
    where: [{ path: /^classes\//, position: 1 }]
  },
  canonicalURL
});
