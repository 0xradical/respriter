import jwtDecode from "jwt-decode";
import cookieJar from "./cookieJar";

export default {
  get() {
    return cookieJar.get("_jwt");
  },

  remove() {
    cookieJar.remove("_jwt", ".lvh.me");
  },

  decode() {
    const value = this.get();
    return value && jwtDecode(value);
  },

  valid() {
    const decoded = this.decode();
    const now = new Date().getTime() / 1000;

    return !!decoded && decoded.exp > now;
  }
};
