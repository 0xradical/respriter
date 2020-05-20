import namespaces from "./namespaces";

const AUTH = "auth";
const GET = "get";
const SET = "set";
const CREATE = "create";
const UPDATE = "update";

export const primitives = {
  AUTH,
  GET,
  SET,
  CREATE,
  UPDATE
};

const types = {
  [namespaces.CERTIFICATE]: { AUTH, GET },
  [namespaces.LOCALE]: { SET },
  [namespaces.PROFILE]: { GET, CREATE, UPDATE },
  [namespaces.USER_ACCOUNT]: { GET, UPDATE }
};

export function namespacedPrimitive(namespace, primitive) {
  return `${namespace}/${primitive}`;
}

export default types;
