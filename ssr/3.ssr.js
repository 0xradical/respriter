exports.ids=[3],exports.modules={1378:function(s,e,r){"use strict";r.r(e);var t=function(){var s=this,e=s.$createElement,r=s._self._c||e;return r("div",{staticClass:"clspt:course-provider c-label",class:s.rootClasses},[r("icon",{staticClass:"c-label__icon c-label__icon--circled-border clspt:course-provider__logo",class:s.logoClasses,attrs:{scope:"providers",name:s.logo}}),s._ssrNode(' <span class="c-label__text"><span'+s._ssrClass("c-tags c-tags--gray3",s.nameClasses)+">"+s._ssrEscape("\n      "+s._s(s.name)+"\n    ")+"</span></span>")],2)};t._withStripped=!0;var o=r(19),n={props:{course:{type:Object,required:!0},rootClasses:{type:Array,default:function(){return[]}},logoClasses:{type:Array,default:function(){return[]}},nameClasses:{type:Array,default:function(){return[]}}},computed:{name:function(){return this.course.provider_name},logo:function(){return this.course.provider_slug}},components:{icon:o.a}},a=r(0);var c=Object(a.a)(n,t,[],!1,function(s){var e=r(927);e.__inject__&&e.__inject__(s)},null,"106d65a8");c.options.__file="app/assets/vue/shared/CourseProvider.vue";e.default=c.exports},723:function(s,e,r){var t=r(928);"string"==typeof t&&(t=[[s.i,t,""]]),t.locals&&(s.exports=t.locals);var o=r(78).default;s.exports.__inject__=function(s){o("af7d8614",t,!1,s)}},927:function(s,e,r){"use strict";r.r(e);var t=r(723),o=r.n(t);for(var n in t)"default"!==n&&function(s){r.d(e,s,function(){return t[s]})}(n);e.default=o.a},928:function(s,e,r){(s.exports=r(77)(!1)).push([s.i,".clspt\\:course-provider {\n  box-sizing: border-box;\n}\n.clspt\\:course-provider__logo {\n    padding: 0;\n}\n",""])}};