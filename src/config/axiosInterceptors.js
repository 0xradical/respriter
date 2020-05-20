import jwt from "./jwt";
import session from "./session";

export default {
  req: {
    suc(conf) {
      jwt.valid()
        ? (conf.headers.common["Authorization"] = "Bearer " + jwt.get())
        : session.logOut();
      return conf;
    },

    err(error) {
      return Promise.reject(error);
    }
  },

  res: {
    suc: undefined,
    err(error) {
      if (error.message && error.message.match(/Invalid token specified/i)) {
        session.logOut();
      }
      if (error.response.status === 401 || error.response.status === 403) {
        session.logOut();
      }
      return Promise.reject(error);
    }
  }
};
