import namespaces from "../namespaces";
import locale from "./locale";
import menu from "./menu";
import progressBar from "./progress_bar";
import profile from "./profile";
import userAccount from "./user_account";

export default {
  [namespaces.LOCALE]: locale,
  [namespaces.MENU]: menu,
  [namespaces.PROGRESS_BAR]: progressBar,
  [namespaces.PROFILE]: profile,
  [namespaces.USER_ACCOUNT]: userAccount
};
