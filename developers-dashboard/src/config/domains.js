import env from "./environment";

const parse = require("url-parse");
let url = parse(env.webAppURL);

const domains = {
  en: `${url.protocol}//${url.host}`,
  "pt-BR": `${url.protocol}//pt-br.${url.host}`,
  es: `${url.protocol}//es.${url.host}`
};

export default domains;
