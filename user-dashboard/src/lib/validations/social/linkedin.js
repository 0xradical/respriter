// https://br.linkedin.com/pub/leticia-cordeiro/0/284/179 (301)
// https://www.linkedin.com/in/leticiacordeiro/
// https://linkedin.com/company/measure-square-corp
// https://linkedin.com/in/javier-márquez-b7b5aa28
// https://linkedin.com/in/ülkü-küçükakın-84850618
// https://linkedin.com/in/антон-булий-55506a142
// https://linkedin.com/in/milan-zivkovic-nlp-hypnosis-coach-online-course-coaching-milanz-courses-nlp-hypnosis-training

import { validate } from "./base";

export const canonicalURL = id => `linkedin.com/in/${id}`;

export const validator = validate({
  host: {
    pattern: /^(?:www\.)?(?:linkedin\.com)$/
  },
  id: {
    pattern: /^(?!.*(?:\/))[A-zÀ-ÿ\d](?:[A-zÀ-ÿ\d]|-(?=[A-zÀ-ÿ\d])){2,99}$/,
    where: [{ path: /^in\//, position: 1 }]
  },
  canonicalURL
});
