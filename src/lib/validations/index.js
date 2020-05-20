import { snakeCase, toLower } from "lodash";

export function mismatch(i18n) {
  return {
    params: [{ name: "other", isTarget: true }],
    validate: (value, { other }) => value === other,
    message: (field, values) => {
      values._field_ = i18n.t(`validations.attributes.${field}`);
      return i18n.t(`validations.messages.${values._rule_}`, values);
    }
  };
}

export function usernameFormat(i18n) {
  return {
    validate: value => {
      if (value) {
        return !value.match(/[^0-9a-zA-Z.\-_]/);
      } else {
        return false;
      }
    },
    message(_, values) {
      return i18n.t(`db.${snakeCase(values._rule_)}`, values);
    }
  };
}

export function usernameConsecutiveDash(i18n) {
  return {
    validate: value => {
      if (value) {
        return !value.match(/--/);
      } else {
        return false;
      }
    },
    message(_, values) {
      return i18n.t(`db.${snakeCase(values._rule_)}`, values);
    }
  };
}

export function usernameConsecutiveUnderline(i18n) {
  return {
    validate: value => {
      if (value) {
        return !value.match(/__/);
      } else {
        return false;
      }
    },
    message(_, values) {
      return i18n.t(`db.${snakeCase(values._rule_)}`, values);
    }
  };
}

export function usernameBoundaryDash(i18n) {
  return {
    validate: value => {
      if (value) {
        return !(value.match(/^-/) || value.match(/-$/));
      } else {
        return false;
      }
    },
    message(_, values) {
      return i18n.t(`db.${snakeCase(values._rule_)}`, values);
    }
  };
}

export function usernameBoundaryUnderline(i18n) {
  return {
    validate: value => {
      if (value) {
        return !(value.match(/^_/) || value.match(/_$/));
      } else {
        return false;
      }
    },
    message(_, values) {
      return i18n.t(`db.${snakeCase(values._rule_)}`, values);
    }
  };
}

export function usernameLowercased(i18n) {
  return {
    validate: value => {
      if (value) {
        return value == toLower(value);
      } else {
        return false;
      }
    },
    message(_, values) {
      return i18n.t(`db.${snakeCase(values._rule_)}`, values);
    }
  };
}

export default {
  mismatch,
  usernameFormat,
  usernameConsecutiveDash,
  usernameConsecutiveUnderline,
  usernameBoundaryDash,
  usernameBoundaryUnderline,
  usernameLowercased
};
