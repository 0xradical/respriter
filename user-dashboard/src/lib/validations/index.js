import { snakeCase, toLower } from "lodash";
import { replace } from "ramda";
import { required } from "vee-validate/dist/rules";
import { isURL } from "~utils";

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
      return i18n.t(
        `db.${replace(/^username_/, "username__", snakeCase(values._rule_))}`,
        values
      );
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
      return i18n.t(
        `db.${replace(/^username_/, "username__", snakeCase(values._rule_))}`,
        values
      );
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
      return i18n.t(
        `db.${replace(/^username_/, "username__", snakeCase(values._rule_))}`,
        values
      );
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
      return i18n.t(
        `db.${replace(/^username_/, "username__", snakeCase(values._rule_))}`,
        values
      );
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
      return i18n.t(
        `db.${replace(/^username_/, "username__", snakeCase(values._rule_))}`,
        values
      );
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
      return i18n.t(
        `db.${replace(/^username_/, "username__", snakeCase(values._rule_))}`,
        values
      );
    }
  };
}

export function platformRequired(i18n) {
  return {
    validate: required.validate,
    message(_, values) {
      return i18n.t("db.public_profile__cannot_be_null", {
        platform: values._field_
      });
    },
    computesRequired: true
  };
}

export function platformFormat(i18n) {
  return {
    params: ["validation"],
    validate: (value, { validation }) => {
      if (value && validation.valid) {
        return true;
      }

      return false;
    },
    message(_, values) {
      return i18n.t("db.public_profile__invalid_format", {
        platform: values._field_
      });
    }
  };
}

export function url(i18n) {
  return {
    validate: value => isURL(value)
  };
}

export default {
  mismatch,
  url,
  usernameFormat,
  usernameConsecutiveDash,
  usernameConsecutiveUnderline,
  usernameBoundaryDash,
  usernameBoundaryUnderline,
  usernameLowercased,
  platformFormat,
  platformRequired
};
