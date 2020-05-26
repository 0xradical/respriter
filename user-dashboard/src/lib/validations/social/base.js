import { pipeWith, identity, match, isEmpty, isNil, replace, __ } from "ramda";
import { isURL, parseURL, normalizeUrl } from "~utils";

// eslint-disable-next-line no-unused-vars
function logger(where) {
  return function (value) {
    // eslint-disable-next-line no-console
    console.log("LOG ", where, ": ", value);
    return value;
  };
}

/**
 *
 * @param {*} arg - Anything
 *
 * @return {*} - If arg is "truthy" returns args, else undefined
 *
 * Truthy is anything but: false, nil, 0, '', [], {}
 */
function truthy(arg) {
  if (arg === false || isNil(arg) || isEmpty(arg)) {
    return undefined;
  } else {
    return arg;
  }
}

/**
 *
 * @param  {...any} fns - A family of functions to be piped
 *
 * @return {Function} A function that will pipe fns until truthy returns undefined
 * in which case will indefinitely return undefined
 */
const pipeWhileTruthy = (...fns) =>
  pipeWith((f, res) => (truthy(res) ? f(res) : truthy(res)))(fns);

function urlize(urlFn) {
  return function (value) {
    if (isURL(value)) {
      return value;
    } else if (isURL(urlFn(value))) {
      return urlFn(value);
    } else if (isURL(normalizeUrl(urlFn(value)))) {
      return normalizeUrl(urlFn(value));
    } else {
      return undefined;
    }
  };
}

function validateHost({ pattern }) {
  return function (value) {
    const { host } = value;
    if (match(pattern, host || "")[0]) {
      return value;
    } else {
      return undefined;
    }
  };
}

function validateID({ pattern, where }) {
  return function (value) {
    const { paths, params } = value;

    for (let i = 0; i < where.length; i++) {
      const w = where[i];

      // if path doesn't match, skip
      if (
        w.path !== undefined &&
        match(w.path, paths.join("/"))[0] === undefined
      ) {
        continue;
      }

      // check for position-based ID
      if (
        w.position !== undefined &&
        paths.slice(w.position).join("/") &&
        match(pattern, paths.slice(w.position).join("/") || "")[0]
      ) {
        return paths.slice(w.position).join("/");
      }

      // check for param-based ID
      if (w.param !== undefined && match(pattern, params[w.param] || "")[0]) {
        return params[w.param];
      }
    }

    return undefined;
  };
}

export function ID({ host, id, canonicalURL }) {
  return pipeWhileTruthy(
    identity,
    urlize(canonicalURL),
    parseURL,
    validateHost(host),
    validateID(id)
  );
}

export function validate(config) {
  return function (value) {
    const { canonicalURL } = config;
    const id = ID(config)(value);

    return {
      id,
      valid: !!id,
      value: id ? canonicalURL(id) : undefined,
      originalValue: value
    };
  };
}
