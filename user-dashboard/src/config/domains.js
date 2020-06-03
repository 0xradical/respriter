import env from "./environment";

const parse = require("url-parse");
let url = parse(env.webAppURL);

const domains = {
  en: `${url.protocol}//${url.host}`,
  "pt-BR": `${url.protocol}//pt-br.${url.host}`,
  es: `${url.protocol}//es.${url.host}`,
  ja: `${url.protocol}//ja.${url.host}`
};

export function webAppDomainURL(domain, path) {
  return domains[domain || "en"] + path;
}

export default domains;
