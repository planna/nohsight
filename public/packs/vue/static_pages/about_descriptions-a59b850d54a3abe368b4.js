!function(e){function t(r){if(n[r])return n[r].exports;var s=n[r]={i:r,l:!1,exports:{}};return e[r].call(s.exports,s,s.exports,t),s.l=!0,s.exports}var n={};t.m=e,t.c=n,t.i=function(e){return e},t.d=function(e,n,r){t.o(e,n)||Object.defineProperty(e,n,{configurable:!1,enumerable:!0,get:r})},t.n=function(e){var n=e&&e.__esModule?function(){return e.default}:function(){return e};return t.d(n,"a",n),n},t.o=function(e,t){return Object.prototype.hasOwnProperty.call(e,t)},t.p="/packs/",t(t.s=61)}({0:function(e,t){e.exports=function(e,t,n,r,s){var o,i=e=e||{},a=typeof e.default;"object"!==a&&"function"!==a||(o=e,i=e.default);var c="function"==typeof i?i.options:i;t&&(c.render=t.render,c.staticRenderFns=t.staticRenderFns),r&&(c._scopeId=r);var u;if(s?(u=function(e){e=e||this.$vnode&&this.$vnode.ssrContext||this.parent&&this.parent.$vnode&&this.parent.$vnode.ssrContext,e||"undefined"==typeof __VUE_SSR_CONTEXT__||(e=__VUE_SSR_CONTEXT__),n&&n.call(this,e),e&&e._registeredComponents&&e._registeredComponents.add(s)},c._ssrRegister=u):n&&(u=n),u){var f=c.functional,d=f?c.render:c.beforeCreate;f?c.render=function(e,t){return u.call(t),d(e,t)}:c.beforeCreate=d?[].concat(d,u):[u]}return{esModule:o,exports:i,options:c}}},43:function(e,t,n){"use strict";t.a={props:["values"],data:function(){return{articles:this.values}}}},53:function(e,t){},61:function(e,t,n){"use strict";function r(e){n(53)}Object.defineProperty(t,"__esModule",{value:!0});var s=n(43),o=n(71),i=n(0),a=r,c=i(s.a,o.a,a,"data-v-7562ef5c",null);t.default=c.exports},71:function(e,t,n){"use strict";var r=function(){var e=this,t=e.$createElement,n=e._self._c||t;return n("div",e._l(e.articles,function(t){return n("div",{staticClass:"section"},[n("h1",{staticClass:"section-header"},[e._v(e._s(t.header))]),e._v(" "),e._l(t.sections,function(t){return n("div",{staticClass:"article"},[n("h2",{staticClass:"article-header"},[e._v(e._s(t.header))]),e._v(" "),e._l(t.contents,function(t){return n("div",["p"==t.tag?n("p",[e._v(e._s(t.resource))]):e._e(),e._v(" "),"img"==t.tag?n("img",{attrs:{src:t.resource}}):e._e()])})],2)})],2)}))},s=[];t.a={render:r,staticRenderFns:s}}});
//# sourceMappingURL=about_descriptions-a59b850d54a3abe368b4.js.map