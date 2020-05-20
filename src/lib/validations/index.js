import _isValidDomain from "is-valid-domain";
import { isURL, domain } from "../utils";
import { snakeCase } from "lodash";
import { inlinedToArray } from "~mixins/inlined-urls";

export function isValidDomain(i18n) {
  return {
    validate: value => _isValidDomain(value),
    message(field, values) {
      values._field_ = i18n.t(`validations.attributes.${field}`);

      return i18n.t(`validations.messages.${snakeCase(values._rule_)}`, values);
    }
  };
}

export function url() {
  return {
    validate: value => isURL(value)
  };
}

export function inlinedUrls(i18n) {
  return {
    params: ["max", "domain"],
    validate: (value, { max = 50, domain = undefined } = {}) => {
      const urls = inlinedToArray(value);
      const urlPathValidator = urlPath(i18n);
      const urlPathMessagePrefix = (line, index) => `URL ${index + 1}) ${line}`;

      if (urls.length > max) {
        return `Should be at most ${max} URLs`;
      }

      if (domain) {
        const urlPathErrors = urls
          .map((url, index) => {
            if (!isURL(url)) {
              return urlPathMessagePrefix(i18n.t(`validations.messages.url`), index);
            } else if (!urlPathValidator.validate(url, { host: domain, excludeRoot: false })) {
              return urlPathMessagePrefix(
                i18n.t(`validations.messages.url_path`, { _field_: url, host: domain }),
                index
              );
            } else {
              return undefined;
            }
          })
          .reduce((acc, value) => {
            if (value) {
              if (!acc) {
                acc = "";
              }
              acc += `${value}<br/>`;
            }
            return acc;
          }, undefined);

        if (urlPathErrors) {
          return urlPathErrors;
        }
      }

      return true;
    }
  };
}

export function urlPath(i18n) {
  return {
    params: ["host", "excludeRoot"],
    validate: (value, { host, excludeRoot }) => {
      let hosts;

      if (Array.isArray(host)) {
        hosts = host;
      } else if (host) {
        hosts = [host];
      } else {
        hosts = [];
      }

      const valueIsURL = isURL(value);
      const valueURI = valueIsURL ? new URL(value) : null;

      if (excludeRoot) {
        return hosts
          .map(host => valueIsURL && valueURI.hostname == host && valueURI.pathname !== "/")
          .reduce((acc, value) => acc || value, false);
      } else {
        return hosts
          .map(host => valueIsURL && valueURI.hostname == host)
          .reduce((acc, value) => acc || value, false);
      }
    },
    message(field, values) {
      const { excludeRoot } = values;
      values._field_ = i18n.t(`validations.attributes.${field}`);

      if (excludeRoot) {
        values._rule_ = `${snakeCase(values._rule_)}_excluded_root`;
      }
      return i18n.t(`validations.messages.${snakeCase(values._rule_)}`, values);
    }
  };
}

export function domainIncludedIn(i18n) {
  return {
    params: ["domains"],
    validate: (value, { domains }) => {
      if (!domains || domains.length === 0) {
        return false;
      }

      if (isURL(value) && domains.indexOf(domain(value)) > -1) {
        return true;
      } else {
        return false;
      }
    },
    message(field, values) {
      values._field_ = i18n.t(`validations.attributes.${field}`);

      return i18n.t(`validations.messages.${snakeCase(values._rule_)}`, values);
    }
  };
}

export function providerNameFormat() {
  return {
    validate: value => {
      return !/[\s!"'#$%&()*+,\-./:;<=>?[\\\]^_`~]+/.test(value);
    },
    message: "name is invalid: forbidden characters present"
  };
}

export default {
  isValidDomain,
  url,
  inlinedUrls,
  urlPath,
  domainIncludedIn,
  providerNameFormat
};
