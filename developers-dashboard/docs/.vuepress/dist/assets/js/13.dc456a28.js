(window.webpackJsonp=window.webpackJsonp||[]).push([[13],{174:function(t,e,o){"use strict";o.r(e);var r=o(27),a=Object(r.a)({},(function(){var t=this,e=t.$createElement,o=t._self._c||e;return o("ContentSlotsDistributor",{attrs:{"slot-key":t.$parent.slotKey}},[o("h1",{attrs:{id:"error-codes"}},[o("a",{staticClass:"header-anchor",attrs:{href:"#error-codes"}},[t._v("#")]),t._v(" Error Codes")]),t._v(" "),o("p",[t._v("During the integration processing, we might display error codes and accompanying hint messages in the following format:")]),t._v(" "),o("pre",{pre:!0,attrs:{class:"language-text"}},[o("code",[t._v("[#XXABCD] Message\n")])]),t._v(" "),o("p",[t._v("Error's XX portion refers to the error class and the ABCD portion refers to the specific error within that class. Here's an exhausting table of all possible error codes and brief explanations:")]),t._v(" "),o("h2",{attrs:{id:"crawling-errors"}},[o("a",{staticClass:"header-anchor",attrs:{href:"#crawling-errors"}},[t._v("#")]),t._v(" Crawling Errors")]),t._v(" "),o("div",{staticClass:"el:m-table EL:M-TABLE"},[o("div",{staticClass:"el:m-table__scrollable-content"},[o("table",[o("thead",[o("tr",[o("th",[t._v("code")]),t._v(" "),o("th",[t._v("description")])])]),t._v(" "),o("tbody",[o("tr",[o("td",[o("strong",[o("code",[t._v("070001")])])]),t._v(" "),o("td",[t._v("Internal Error. Something wrong happened when Classpert Bot crawled your course's page, due to something you or us did wrong")])]),t._v(" "),o("tr",[o("td",[o("strong",[o("code",[t._v("070002")])])]),t._v(" "),o("td",[t._v("Page Fetch Error. Could not retrieve a sitemap page, with status codes being 2xx or 3xx")])]),t._v(" "),o("tr",[o("td",[o("strong",[o("code",[t._v("070003")])])]),t._v(" "),o("td",[t._v("Page Fetch Error. Could not retrieve a course page, with status codes being 2xx or 3xx")])]),t._v(" "),o("tr",[o("td",[o("strong",[o("code",[t._v("070004")])])]),t._v(" "),o("td",[t._v("Invalid Course Error. Fields in your JSON are not valid")])]),t._v(" "),o("tr",[o("td",[o("strong",[o("code",[t._v("070005")])])]),t._v(" "),o("td",[t._v("Invalid Course Description. Your course's description field is not a valid Markdown source or has forbidden content like links, images os html tags")])]),t._v(" "),o("tr",[o("td",[o("strong",[o("code",[t._v("070006")])])]),t._v(" "),o("td",[t._v("Invalid Classpert Metadata Error. You have malformed JSON on your page")])]),t._v(" "),o("tr",[o("td",[o("strong",[o("code",[t._v("070007")])])]),t._v(" "),o("td",[t._v("Multiple Courses on Page. Right now we don't support pages with more than one course (this could change soon)")])]),t._v(" "),o("tr",[o("td",[o("strong",[o("code",[t._v("070008")])])]),t._v(" "),o("td",[t._v("Unverified URL domain on course. You pointed to an URL on your course page that is not verified as owned by you")])]),t._v(" "),o("tr",[o("td",[o("strong",[o("code",[t._v("070009")])])]),t._v(" "),o("td",[t._v("Unverified URL domain on sitemap. You pointed to an URL on your sitemap that is not verified as owned by you")])]),t._v(" "),o("tr",[o("td",[o("strong",[o("code",[t._v("070010")])])]),t._v(" "),o("td",[t._v("Malformed Sitemap. You pointed an invalid sitemap url that does not contain any page url or other page url.")])])])])])]),o("h2",{attrs:{id:"domain-validation-errors"}},[o("a",{staticClass:"header-anchor",attrs:{href:"#domain-validation-errors"}},[t._v("#")]),t._v(" Domain Validation Errors")]),t._v(" "),o("div",{staticClass:"el:m-table EL:M-TABLE"},[o("div",{staticClass:"el:m-table__scrollable-content"},[o("table",[o("thead",[o("tr",[o("th",[t._v("code")]),t._v(" "),o("th",[t._v("description")])])]),t._v(" "),o("tbody",[o("tr",[o("td",[o("strong",[o("code",[t._v("100000")])])]),t._v(" "),o("td",[t._v("Domain structure not found on database")])]),t._v(" "),o("tr",[o("td",[o("strong",[o("code",[t._v("100001")])])]),t._v(" "),o("td",[t._v("Domain's associated user not found on database")])]),t._v(" "),o("tr",[o("td",[o("strong",[o("code",[t._v("100002")])])]),t._v(" "),o("td",[t._v("Domain already validated")])]),t._v(" "),o("tr",[o("td",[o("strong",[o("code",[t._v("100003")])])]),t._v(" "),o("td",[t._v("Domain already taken")])]),t._v(" "),o("tr",[o("td",[o("strong",[o("code",[t._v("100004")])])]),t._v(" "),o("td",[t._v("Domain validation failed temporarily, will try again")])]),t._v(" "),o("tr",[o("td",[o("strong",[o("code",[t._v("100005")])])]),t._v(" "),o("td",[t._v("Domain validation failed permanently, restart process")])]),t._v(" "),o("tr",[o("td",[o("strong",[o("code",[t._v("100006")])])]),t._v(" "),o("td",[t._v("Name derived from domain url cannot be used")])]),t._v(" "),o("tr",[o("td",[o("strong",[o("code",[t._v("100007")])])]),t._v(" "),o("td",[t._v("Name derivation from domain failed")])]),t._v(" "),o("tr",[o("td",[o("strong",[o("code",[t._v("100008")])])]),t._v(" "),o("td",[t._v("Domain configuration failed")])]),t._v(" "),o("tr",[o("td",[o("strong",[o("code",[t._v("100009")])])]),t._v(" "),o("td",[t._v("Domain already being validated")])])])])])]),o("h2",{attrs:{id:"sitemap-validation-errors"}},[o("a",{staticClass:"header-anchor",attrs:{href:"#sitemap-validation-errors"}},[t._v("#")]),t._v(" Sitemap Validation Errors")]),t._v(" "),o("div",{staticClass:"el:m-table EL:M-TABLE"},[o("div",{staticClass:"el:m-table__scrollable-content"},[o("table",[o("thead",[o("tr",[o("th",[t._v("code")]),t._v(" "),o("th",[t._v("description")])])]),t._v(" "),o("tbody",[o("tr",[o("td",[o("strong",[o("code",[t._v("110000")])])]),t._v(" "),o("td",[t._v("Sitemap structure not found on database")])]),t._v(" "),o("tr",[o("td",[o("strong",[o("code",[t._v("110001")])])]),t._v(" "),o("td",[t._v("Sitemap URL returned non-successful status code (response code is not 200)")])]),t._v(" "),o("tr",[o("td",[o("strong",[o("code",[t._v("110002")])])]),t._v(" "),o("td",[t._v("Sitemap XML file provided is not valid")])]),t._v(" "),o("tr",[o("td",[o("strong",[o("code",[t._v("110003")])])]),t._v(" "),o("td",[t._v("Sitemap provided is not a well-formed XML file")])]),t._v(" "),o("tr",[o("td",[o("strong",[o("code",[t._v("110004")])])]),t._v(" "),o("td",[t._v("Sitemap detection failed")])])])])])]),o("h2",{attrs:{id:"debug-tool-errors"}},[o("a",{staticClass:"header-anchor",attrs:{href:"#debug-tool-errors"}},[t._v("#")]),t._v(" Debug Tool Errors")]),t._v(" "),o("div",{staticClass:"el:m-table EL:M-TABLE"},[o("div",{staticClass:"el:m-table__scrollable-content"},[o("table",[o("thead",[o("tr",[o("th",[t._v("code")]),t._v(" "),o("th",[t._v("description")])])]),t._v(" "),o("tbody",[o("tr",[o("td",[o("strong",[o("code",[t._v("120000")])])]),t._v(" "),o("td",[t._v("Debug structure not found on database")])]),t._v(" "),o("tr",[o("td",[o("strong",[o("code",[t._v("120001")])])]),t._v(" "),o("td",[t._v("Classpert URI not set")])]),t._v(" "),o("tr",[o("td",[o("strong",[o("code",[t._v("120002")])])]),t._v(" "),o("td",[t._v("Course page returned non-successful status code (response code is not 200)")])]),t._v(" "),o("tr",[o("td",[o("strong",[o("code",[t._v("120003")])])]),t._v(" "),o("td",[t._v("Course page doesn't have a vnd.classpert+json structure")])]),t._v(" "),o("tr",[o("td",[o("strong",[o("code",[t._v("120004")])])]),t._v(" "),o("td",[t._v("Course page's vnd.classpert+json structure is malformed")])]),t._v(" "),o("tr",[o("td",[o("strong",[o("code",[t._v("120005")])])]),t._v(" "),o("td",[t._v("Course page's vnd.classpert+json is not valid")])]),t._v(" "),o("tr",[o("td",[o("strong",[o("code",[t._v("120006")])])]),t._v(" "),o("td",[t._v("Debug structure could not be generated")])]),t._v(" "),o("tr",[o("td",[o("strong",[o("code",[t._v("120007")])])]),t._v(" "),o("td",[t._v("Debug screenshotting failed")])])])])])])])}),[],!1,null,null,null);e.default=a.exports}}]);