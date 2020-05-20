import namespaces from "../namespaces";
import certificate from "./certificate";
import locale from "./locale";
import menu from "./menu";
import progress_bar from "./progress_bar";
import profile from "./profile";
import user_account from "./user_account";

export default {
  [namespaces.CERTIFICATE]: certificate,
  [namespaces.LOCALE]: locale,
  [namespaces.MENU]: menu,
  [namespaces.PROGRESS_BAR]: progress_bar,
  [namespaces.PROFILE]: profile,
  [namespaces.USER_ACCOUNT]: user_account
};
