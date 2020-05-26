import { validate } from "./base";

export const canonicalURL = id => `soundcloud.com/${id}`;

export const validator = validate({
  host: {
    pattern: /^(?:www\.)?(?:soundcloud\.com)$/
  },
  id: {
    pattern: /^(?!.*(?:\/))(?:[a-z\d](?:[a-z\d]|[-_](?=[a-z\d])){2,24})$/,
    where: [{ position: 0 }]
  },
  canonicalURL
});
