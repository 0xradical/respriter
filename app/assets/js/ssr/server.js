import { renderVue, Vue } from './hypernova-vue';
import hypernova from 'hypernova/server';

// common
import { createI18n } from '../i18n';
import CoursePage from '../../vue/apps/course_page/App.vue';

hypernova({
  getComponent(name, context) {
    const { props } = context;
    const locale = (props && props.locale) || 'en';

    if (name === 'course_page.js') {
      let component = Vue.extend(CoursePage);
      component.__instanceLevelProperties = { i18n: createI18n(locale) };

      return renderVue("course_page.js", component);
    }

    return null;
  },
  port: 7777,
});