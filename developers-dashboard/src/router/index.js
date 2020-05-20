import Vue from "vue";
import VueRouter from "vue-router";

Vue.use(VueRouter);

// Import Session
import session from "../config/session";

// Components
import Home from "../components/Home.vue";
import DomainNew from "../components/domain/New";
import DomainEdit from "../components/domain/Edit";
// import DomainConfig from "../components/domain/Config";
// import DomainSitemap from "../components/domain/Sitemap";
import DomainDebugTool from "../components/domain/DebugTool";
import DomainIndexingStatus from "../components/domain/IndexingStatus";
import DomainSettings from "../components/domain/Settings";

const routes = [
  {
    path: "/",
    redirect: "/dashboard"
  },
  {
    path: "/dashboard",
    name: "root",
    component: Home,
    meta: { requiresAuth: true },
    children: [
      {
        path: "debug-tools",
        name: "debug-tools",
        component: DomainDebugTool,
        meta: {
          hideNavigation: true
        }
      },
      {
        path: "domains",
        name: "domain",
        component: DomainNew,
        meta: {
          hideNavigation: true
        }
      },
      {
        path: "domains/:domain",
        name: "domain-edit",
        redirect: "domains/:domain/status",
        component: DomainEdit,
        children: [
          {
            path: "status",
            name: "domain-status",
            component: DomainIndexingStatus,
            meta: {
              parent: "domain"
            }
          },
          {
            path: "settings",
            name: "domain-settings",
            component: DomainSettings,
            meta: {
              parent: "domain"
            }
          }
        ]
      }
    ]
  }
];

const router = new VueRouter({
  mode: "history",
  routes
});

// Authenticate and request a JWT
router.beforeEach((to, _from, next) => {
  const redirPath = to.query.developers_dashboard_redir;

  if (session.isLoggedIn()) {
    next(redirPath);
  } else {
    next(false);
    session.requireSignIn(to.path);
  }
});

export default router;
