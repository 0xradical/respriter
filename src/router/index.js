import Vue from "vue";
import VueRouter from "vue-router";

Vue.use(VueRouter);

// Import Session
import session from "../config/session";

// Components
import Home from "../components/Home.vue";
import AccountSettings from "../components/AccountSettings.vue";
import Interests from "../components/Interests.vue";

const routes = [
  {
    path: "/",
    name: "root",
    redirect: "/account-settings",
    component: Home,
    children: [
      {
        path: "/account-settings",
        name: "account-settings",
        component: AccountSettings
      },
      {
        path: "/interests",
        name: "interests",
        component: Interests
      }
    ]
  }
];

const router = new VueRouter({
  mode: "history",
  routes
});

// Authenticate and request a JWT
router.beforeEach((to, from, next) => {
  let redirPath = to.query.user_dashboard_redir;

  if (session.isLoggedIn()) {
    next(redirPath);
  } else {
    next(false);
    session.requireSignIn(to.path);
  }
});

export default router;
