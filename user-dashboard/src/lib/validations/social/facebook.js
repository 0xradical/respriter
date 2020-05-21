// https://facebook.com/nethan.petrolie
// https://facebook.com/100018839703689 (301)
// https://www.facebook.com/profile.php?id=100018839703689
// https://www.facebook.com/%EB%A1%9C%EC%A7%80%EC%95%84-%EC%B6%9C%EC%82%B0%EC%97%B0%EA%B5%AC%EC%86%8C-518672775193040/ (hangul)

// rules
// either a 15-digit identifier
// or a sequence of [A-z\d.-] which has:
// at least 5 characters
// at most 51 characters

import { validate } from "./base";

export const canonicalURL = id => `facebook.com/${id}`;

export const validator = validate({
  host: {
    pattern: /^(?:www\.|m\.|mobile\.|touch\.|mbasic\.)?(?:facebook\.com|fb(?:\.me|\.com))$/
  },
  id: {
    pattern: /^(?!.*(?:\/))(?:(?:(?:[A-z\d])(?:[A-z\d]|[.-](?=[A-z\d])){4,50})|(?:\d{15}))$/,
    where: [{ path: /^profile\.php\/?$/, param: "id" }, { position: 0 }]
  },
  canonicalURL
});
