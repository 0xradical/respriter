// https://instagram.com/paustephens

import { validate } from "./base";

export const canonicalURL = id => `instagram.com/${id}`;

export const validator = validate({
  host: {
    pattern: /^(?:www\.)?(?:instagram\.com)$/
  },
  id: {
    pattern: /^(?!.*(?:\/))([A-z\d._](?:(?:[A-z\d._]|(?:\.(?!\.))){2,28}(?:[A-z\d._]))?)$/,
    where: [{ position: 0 }]
  },
  canonicalURL
});
