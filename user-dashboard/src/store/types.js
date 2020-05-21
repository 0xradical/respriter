import namespaces from "./namespaces";

const AUTH = "auth";
const GET = "get";
const SET = "set";
const CREATE = "create";
const UPDATE = "update";

export const operations = {
  AUTH,
  GET,
  SET,
  CREATE,
  UPDATE
};

const types = {
  [namespaces.LOCALE]: { SET },
  [namespaces.PROFILE]: { GET, CREATE, UPDATE },
  [namespaces.USER_ACCOUNT]: { GET, UPDATE }
};

export function namespacedOperation(namespace, operation) {
  return `${namespace}/${operation}`;
}

export default types;
