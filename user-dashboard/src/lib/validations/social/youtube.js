// https://youtube.com/channel/UCjjyDkD7S31A8XuK14mQyAA
// https://youtube.com/c/englishwithmichael
// TODO: Match both

import { validate } from "./base";

export const canonicalURL = id => `youtube.com/channel/${id}`;

export const validator = validate({
  host: {
    pattern: /^(?:www\.)?(?:youtube\.com)$/
  },
  id: {
    pattern: /^(?!.*(?:\/))UC(?:[A-z\d_-]){22}$/,
    where: [{ path: /^channel\//, position: 1 }]
  },
  canonicalURL
});
