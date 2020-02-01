import hypernova from "hypernova/server";
import CoursePage from "../vue/apps/course_page";
import SearchPage from "../vue/apps/search_page";
import Sharing from "../vue/apps/sharing";
import VCard from "../vue/apps/vcard";

hypernova({
  getComponent(name, context) {
    if (name === "VCard") {
      return VCard();
    }

    if (name === "Sharing") {
      return Sharing();
    }

    if (name === "CoursePage") {
      return CoursePage();
    }

    if (name === "SearchPage") {
      return SearchPage();
    }

    return null;
  },
  port: 7777
});
