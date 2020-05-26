import hypernova from "hypernova/server";
import Apps from "../vue/apps";

hypernova({
  getComponent(name, context) {
    if (Apps[name]) {
      console.log("Rendering " + name);
      return Apps[name]();
    }
    console.log("Unknown component " + name);
    return null;
  },
  port: 7777
});
