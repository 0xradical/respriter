import _normalizeUrl from "normalize-url";
import _isURL from "validator/lib/isURL";
import { snakeCase, camelCase } from "lodash";
import {
  zipObj,
  pick,
  keys,
  values,
  map,
  isEmpty,
  curry,
  both,
  identity,
  mergeDeepRight,
  split,
  tail,
  without,
  compose,
  __
} from "ramda";

/**
 * If obj is "an object" then recurse with mapKeys
 */
const parseValues = curry((fn, obj) => {
  if (isEmpty(keys(obj))) {
    return obj;
  } else {
    return mapKeys(fn, obj);
  }
});

const mapKeys = curry((fn, obj) => {
  if (Array.isArray(obj)) {
    return map(parseValues(fn), values(obj));
  } else {
    return zipObj(map(fn, keys(obj)), map(parseValues(fn), values(obj)));
  }
});

/**
 * Immutable, point-free deep camelizer of object properties
 *
 *
 * @param {object} input - Object whose keys will be deeply camelized
 *
 * @return {object} output - Deep copy of "input" with deeply camelized keys
 *
 * @example:
 *
 * camelCasedKeys({a_key: { another_key: 1} }) => { aKey: { anotherKey: 1} }
 *
 */
export const shallowCamelCasedKeys = o =>
  zipObj(map(camelCase, keys(o)), values(o));
export const camelCasedKeys = mapKeys(camelCase);
/**
 *  Immutable, point-free deep snakelizer of object properties
 */
export const snakeCasedKeys = mapKeys(snakeCase);

/**
 * Immutable, point-free URL normalizer, equivalent to:
 * function normalizeUrl(url) { ... }
 *
 * It will not run the _normalizeUrl function if "url"
 * is nullish
 *
 * @param {string} URL
 *
 * @return {string} Normalized URL
 *
 * @example
 *
 *    normalizeUrl("google.com")
 *    "https://google.com"
 *
 *    normalizeUrl("https://google.com")
 *    "https://google.com"
 */
export const normalizeUrl = both(
  identity,
  curry(_normalizeUrl)(__, {
    defaultProtocol: "https:"
  })
);

/**
 *
 * @param {string} A string that may or may not be an URL
 *
 * @return {boolean} Whether value is an URL or not
 *
 *
 */
export function isURL(value) {
  if (!value) {
    return false;
  }

  return _isURL(value, {
    require_protocol: true,
    protocols: ["http", "https"]
  });
}

/**
 *
 * @example
 *
 * parseURL("https://mobile.classpert.com/a/b/c.php?abc=123#id")
 *
 * {
 *    protocol: "https:",
 *    host: "mobile.classpert.com",
 *    paths: ["a", "b", "c.php"]
 * }
 */
export function parseURL(value) {
  if (isURL(value)) {
    const url = new URL(value);
    const pathname =
      url.pathname.charAt(0) === "/" ? url.pathname : "/" + url.pathname;

    return {
      ...pick(["protocol", "host"], url),
      params: Object.fromEntries(url.searchParams.entries()),
      paths: compose(map(decodeURI), without([""]), tail, split("/"))(pathname)
    };
  } else {
    return {};
  }
}

export function safeJSONParse(anything) {
  try {
    return JSON.parse(anything);
  } catch (_) {
    return {};
  }
}

/**
 *
 * @param {object} state from Vuex
 *
 * @return {function} A merging function "f"
 *
 * The merging function "f", when called with another object "payload",
 * will perform a merge prioritizing the "payload" data over "state"
 */
export function update(state) {
  return function (payload) {
    const merge = mergeDeepRight(state, payload);

    for (const key in merge) {
      if (Object.prototype.hasOwnProperty.call(merge, key)) {
        state[key] = merge[key];
      }
    }
  };
}

/**
 *
 * @param {function} callback
 *
 * @return {function} A event handler "f"
 *
 * The event handler "f", when called with an "event",
 * will do a transformation based on "callback" before pasting content
 *
 */
export function onpaste(callback) {
  return function (event) {
    const clipboardData = event.clipboardData || window.clipboardData;
    const paste = clipboardData.getData("text");
    return callback(paste);
  };
}
