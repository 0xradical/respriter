import { camelCase } from "lodash";
import _isURL from "validator/lib/isURL";
import psl from "psl";

export function update(state, payload) {
  for (const key in payload) {
    if (Object.prototype.hasOwnProperty.call(payload, key)) {
      state[camelCase(key)] = payload[key];
    }
  }
}

export function secondsSinceEpoch() {
  return new Date() / 1000;
}

export function intlDateFormatter(date) {
  return date.toISOString();
}

export function daysFromNow(days) {
  const today = new Date();

  return today.setDate(today.getDate() + parseInt(days));
}

export function isURL(value) {
  if (!value) {
    return false;
  }

  return _isURL(value, {
    require_protocol: true,
    protocols: ["http", "https"]
  });
}

export function domain(value) {
  if (isURL(value)) {
    const url = new URL(value);
    return psl.parse(url.host).input;
  } else {
    return null;
  }
}

export function delay(seconds) {
  return new Promise(resolve => setTimeout(resolve, seconds));
}
