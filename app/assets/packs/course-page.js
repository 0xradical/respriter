import Vue from 'vue';
// common
import { createI18n } from '../js/i18n';
import CoursePage from '../vue/apps/course_page/App.vue';
import _ from 'lodash';

document.addEventListener('DOMContentLoaded', () => {
  // loaded by Rails, hydrated by Vue
  // [data-server-rendered="true"]')
  const nodes = Array.prototype.map.call(document.querySelectorAll('div[data-hypernova-key="course_pagejs"]'), (node) => {
    let vueNode  = node.querySelector('div[data-server-rendered="true"]');
    // if node ssr is offline
    // create a div and inject client-side Vue
    if(vueNode == null) {
      vueNode = document.createElement("div");
      vueNode.dataset['vueCoursePage'] = '';
      node.appendChild(vueNode);
    }

    const jsonCdata = document.querySelector(`script[data-hypernova-id="${node.dataset['hypernovaId']}"]`).innerHTML;
    const vueProps = JSON.parse(_.unescape(jsonCdata.slice(4, jsonCdata.length - 3)));
    return {
      node: vueNode,
      props: vueProps
    }
  })

  for(let i = 0; i < nodes.length; ++i) {
    const { node, props } = nodes[i];

    const app = new Vue({
      i18n: createI18n(props.locale || 'en'),
      render: h => h(CoursePage, { props: props })
    });

    app.$mount(node);
  }
});