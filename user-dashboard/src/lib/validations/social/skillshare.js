// https://skillshare.com/profile/Carolina-Mendieta/1842168
// https://skillshare.com/user/cc_trading
// TODO: Match both

import { validate } from "./base";

export const canonicalURL = id => `skillshare.com/user/${id}`;

export const validator = validate({
  host: {
    pattern: /^(?:www\.)?(?:skillshare\.com)$/
  },
  id: {
    pattern: /^(?!.*(?:\/))(?:[a-z\d\-_]{3,30})$/,
    where: [{ path: /^user\//, position: 1 }]
  },
  canonicalURL
});
