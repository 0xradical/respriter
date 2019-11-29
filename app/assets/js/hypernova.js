import hypernova from "hypernova/server";
import CoursePage from "../vue/apps/course_page";

hypernova({
  getComponent(name, context) {
    if (name === "CoursePage") {
      return CoursePage;
    }

    return null;
  },
  port: 7777
});
