import namespaces from "./namespaces";

const GET = "get";
const CREATE = "create";
const LIST = "list";
const UPDATE = "update";
const START = "start";
const STOP = "stop";
const AUTH = "auth";
const RESET = "reset";

export const operations = {
  GET,
  CREATE,
  LIST,
  UPDATE,
  START,
  STOP,
  AUTH
};

const types = {
  [namespaces.CRAWLER_DOMAIN]: { GET, CREATE, LIST },
  [namespaces.CRAWLING_EVENT]: { GET },
  [namespaces.PREVIEW_COURSE]: { GET, CREATE },
  [namespaces.PROFILE]: { GET },
  [namespaces.PROVIDER]: { UPDATE },
  [namespaces.PROVIDER_CRAWLER]: { GET, CREATE, LIST, UPDATE, START, STOP },
  [namespaces.PROVIDER_LOGO]: { AUTH, GET, RESET },
  [namespaces.SHARED]: { UPDATE }
};

export function namespacedOperation(namespace, operation) {
  return `${namespace}/${operation}`;
}

export default types;
