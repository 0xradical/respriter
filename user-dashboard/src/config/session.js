import jwt from "./jwt";
import { webAppDomainURL } from "./domains";
import { paths } from "./environment";

export default {
  logInURL() {
    return webAppDomainURL("en", paths.logInPath);
  },

  logOutURL() {
    return webAppDomainURL("en", paths.logOutPath);
  },

  getApiAuthHeader() {
    return `Bearer ${jwt.get()}`;
  },

  getUserId() {
    try {
      return jwt.decode().sub;
    } catch (error) {
      return null;
    }
  },

  isLoggedIn() {
    try {
      if (!jwt.valid()) {
        this.logOut();
        return false;
      }
      return true;
    } catch (err) {
      return false;
    }
  },

  requireSignIn(redirPath = "/") {
    let url = `${this.logInURL()}?user_dashboard_redir=${decodeURIComponent(
      redirPath
    )}`;
    location.replace(url);
  },

  logOut() {
    window.location.replace(this.logOutURL());
  }
};
