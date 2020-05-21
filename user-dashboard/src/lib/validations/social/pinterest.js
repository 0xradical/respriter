// https://pinterest.ca/cmeenu34
// https://pinterest.co.uk/Jennysiscrafts

import { validate } from "./base";

export const canonicalURL = id => `pinterest.com/${id}`;

export const validator = validate({
  host: {
    pattern: /^(?:(?:(?:(?:www|at|au|be|bo|br|ca|ch|cl|de|dk|ec|ec|es|fr|hu|id|ie|in|it|jp|kr|mx|mx|nl|nz|pe|pe|ph|pt|pt|py|ru|th|tw|uk|uy|vn|vn)\.)?pinterest\.com)|(?:pinterest\.(?:at|be|br|ca|ch|cl|co(?:\.(?:at|id|in|kr|nz|uk))?|de|dk|ec|es|fr|hu|id|ie|in|it|jp|kr|mx|nl|nz|pe|ph|pt|ru|th|tw|uk|vn|com(?:\.(?:au|bo|br|ec|mx|pe|pt|py|uy|vn))?|info|biz)))$/
  },
  id: {
    pattern: /^(?!.*(?:\/))[A-z\d](?:[A-z\d]|_){2,29}$/,
    where: [{ position: 0 }]
  },
  canonicalURL
});
