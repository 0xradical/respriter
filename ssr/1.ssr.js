exports.ids=[1],exports.modules={1174:function(t,e,s){"use strict";s.r(e);var o=s(568),a=s.n(o);for(var r in o)"default"!==r&&function(t){s.d(e,t,function(){return o[t]})}(r);e.default=a.a},1175:function(t,e,s){(t.exports=s(77)(!1)).push([t.i,".clspt\\:course-attribute {\n  box-sizing: border-box;\n}\n.clspt\\:course-attribute__icon {\n    position: relative;\n}\n.clspt\\:course-attribute__icon--clock {\n      top: -1;\n}\n.clspt\\:course-attribute__label {\n    max-height: 1em;\n    overflow: hidden;\n    max-width: 90%;\n    white-space: nowrap;\n    text-overflow: ellipsis;\n}\n",""])},1176:function(t,e,s){"use strict";s.r(e);var o=s(569),a=s.n(o);for(var r in o)"default"!==r&&function(t){s.d(e,t,function(){return o[t]})}(r);e.default=a.a},1177:function(t,e,s){(t.exports=s(77)(!1)).push([t.i,".clspt\\:course-attribute-list {\n  min-width: 0;\n}\n",""])},1178:function(t,e,s){"use strict";s.r(e);var o=function(){var t=this,e=t.$createElement,s=t._self._c||e;return s("div",{staticClass:"clspt:course-attribute-list",class:t.rootClasses},[t.showUnavailable||t.course.root_audio&&t.course.root_audio.length>0?s("course-attribute",{attrs:{icon:"audio",rootClasses:t.attributeClasses,iconClasses:t.attributeIconClasses}},[t.course.root_audio&&t.course.root_audio.length>0?[s("span",{staticClass:"el:amx-Tt(u)"},[t._v(t._s(t.course.root_audio.join(",")))])]:[t._v("\n      "+t._s(t.$t("dictionary.not_available"))+"\n    ")]],2):t._e(),t._ssrNode(" "),t.showUnavailable||t.course.root_subtitles&&t.course.root_subtitles.length>0?s("course-attribute",{attrs:{icon:"cc",rootClasses:t.attributeClasses,iconClasses:t.attributeIconClasses}},[t.course.root_subtitles&&t.course.root_subtitles.length>0?[s("span",{staticClass:"el:amx-Tt(u)"},[t._v(t._s(t.course.root_subtitles.slice(0,5).join(",")))])]:[t._v("\n      "+t._s(t.$t("dictionary.not_available"))+"\n    ")]],2):t._e(),t._ssrNode(" "),t.showUnavailable||t.course.certificate&&t.course.certificate.type?s("course-attribute",{attrs:{icon:"certificate",rootClasses:t.attributeClasses,iconClasses:t.attributeIconClasses}},[t.course.certificate&&t.course.certificate.type?[t._v("\n      "+t._s(t.$t("dictionary.certificate."+t.course.certificate.type))+"\n    ")]:[t._v("\n      "+t._s(t.$t("dictionary.not_available"))+"\n    ")]],2):t._e(),t._ssrNode(" "),t.showUnavailable||t.course.offered_by&&t.course.offered_by.length>0?s("course-attribute",{attrs:{icon:"building",rootClasses:t.attributeClasses,iconClasses:t.attributeIconClasses}},[t.course.offered_by&&t.course.offered_by.length>0?[t._v("\n      "+t._s(t.course.offered_by.map(function(t){return t.name}).join(","))+"\n    ")]:[t._v("\n      "+t._s(t.$t("dictionary.not_available"))+"\n    ")]],2):t._e(),t._ssrNode(" "),t.showUnavailable||t.course.instructors&&t.course.instructors.length>0?s("course-attribute",{attrs:{icon:"nametag",rootClasses:t.attributeClasses,iconClasses:t.attributeIconClasses}},[t.course.instructors&&t.course.instructors.length>0?[t._v("\n      "+t._s(t.course.instructors.map(function(t){return t.name}).join(","))+"\n    ")]:[t._v("\n      "+t._s(t.$t("dictionary.not_available"))+"\n    ")]],2):t._e(),t._ssrNode(" "),t.showUnavailable||t.course.pace?s("course-attribute",{attrs:{icon:"velocimeter",rootClasses:t.attributeClasses,iconClasses:t.attributeIconClasses}},[t.course.pace?[t._v("\n      "+t._s(t.$t("dictionary.pace."+t.course.pace))+"\n    ")]:[t._v("\n      "+t._s(t.$t("dictionary.not_available"))+"\n    ")]],2):t._e(),t._ssrNode(" "),t.showUnavailable||t.course.level&&t.course.level.length>0?s("course-attribute",{attrs:{icon:"level",rootClasses:t.attributeClasses,iconClasses:t.attributeIconClasses}},[t.course.level&&t.course.level.length>0?[t._v("\n      "+t._s(t.course.level.map(function(e){return t.$t("dictionary.levels."+e)}).join(","))+"\n    ")]:[t._v("\n      "+t._s(t.$t("dictionary.not_available"))+"\n    ")]],2):t._e(),t._ssrNode(" "),t.showUnavailable||t.course.effort?s("course-attribute",{attrs:{icon:"clock",rootClasses:t.attributeClasses,iconClasses:t.attributeIconClasses}},[t.course.effort?[t._v("\n      "+t._s(t.$t("datetime.distance_in_words.x_hours."+(1==t.course.effort?"one":"other"),{count:t.course.effort}))+"\n    ")]:[t._v("\n      "+t._s(t.$t("dictionary.not_available"))+"\n    ")]],2):t._e()],2)};o._withStripped=!0;var a=function(){var t=this,e=t.$createElement,s=t._self._c||e;return s("div",{staticClass:"clspt:course-attribute c-label",class:t.rootClasses},[s("icon",{attrs:{iconClasses:t.iconClassesBase.concat(t.iconClasses),name:t.icon}}),t._ssrNode(" "),t._ssrNode('<span class="clspt:course-attribute__label c-label__text">',"</span>",[t._ssrNode("<span"+t._ssrClass("c-tags c-tags--gray3",t.valueClasses)+">","</span>",[t._t("default")],2)])],2)};a._withStripped=!0;var r=s(26),n={props:{rootClasses:{type:Array,default:function(){return[]}},iconClasses:{type:Array,default:function(){return[]}},valueClasses:{type:Array,default:function(){return[]}},icon:{type:String}},components:{icon:r.a},computed:{iconClassesBase:function(){return["c-label__icon","clspt:course-attribute__icon","clspt:course-attribute__icon--".concat(this.icon)]}}},i=s(2);var c=Object(i.a)(n,a,[],!1,function(t){var e=s(1174);e.__inject__&&e.__inject__(t)},null,"a18f5516");c.options.__file="app/assets/vue/shared/CourseAttribute.vue";var u=c.exports,l={props:{course:{type:Object,required:!0},showUnavailable:{type:Boolean,default:!0},rootClasses:{type:Array,default:function(){return[]}},attributeClasses:{type:Array,default:function(){return[]}},attributeIconClasses:{type:Array,default:function(){return[]}}},components:{courseAttribute:u}};var _=Object(i.a)(l,o,[],!1,function(t){var e=s(1176);e.__inject__&&e.__inject__(t)},null,"fcad969a");_.options.__file="app/assets/vue/shared/CourseAttributeList.vue";e.default=_.exports},568:function(t,e,s){var o=s(1175);"string"==typeof o&&(o=[[t.i,o,""]]),o.locals&&(t.exports=o.locals);var a=s(78).default;t.exports.__inject__=function(t){a("adf47140",o,!1,t)}},569:function(t,e,s){var o=s(1177);"string"==typeof o&&(o=[[t.i,o,""]]),o.locals&&(t.exports=o.locals);var a=s(78).default;t.exports.__inject__=function(t){a("a5bcea48",o,!1,t)}}};