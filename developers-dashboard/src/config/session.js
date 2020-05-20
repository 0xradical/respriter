import jwt from "./jwt";
import domains from "./domains";

// Log in | Log out paths
const logInPath = "/developers/sign_in";
const logOutPath = "/user_accounts/sign_out";

export function logInURL() {
  return domains["en"] + logInPath;
}

export function logOutURL() {
  return domains["en"] + logOutPath;
}

export function getApiAuthHeader() {
  return `Bearer ${jwt.get()}`;
}

export function getUserId() {
  try {
    return jwt.decode().sub;
  } catch (error) {
    return null;
  }
}

export function isLoggedIn() {
  try {
    if (!jwt.valid()) {
      this.logOut();
      return false;
    }
    return true;
  } catch (err) {
    return false;
  }
}

export function requireSignIn(redirPath = "/dashboard") {
  let url = `${this.logInURL()}?developers_dashboard_redir=${decodeURIComponent(redirPath)}`;
  location.replace(url);
}

export function logOut() {
  window.location.replace(this.logOutURL());
}

export default {
  logInURL,
  logOutURL,
  getApiAuthHeader,
  getUserId,
  isLoggedIn,
  requireSignIn,
  logOut
};
