// fences (``` lang, ~~~ lang)

"use strict";

var assign = require("markdown-it/lib/common/utils").assign;
var unescapeAll = require("markdown-it/lib/common/utils").unescapeAll;
var escapeHtml = require("markdown-it/lib/common/utils").escapeHtml;

module.exports = function fence(tokens, idx, options, env, slf) {
  var token = tokens[idx],
    info = token.info ? unescapeAll(token.info).trim() : "",
    langName = "",
    highlighted,
    i,
    tmpAttrs,
    tmpToken;

  if (info) {
    langName = info.split(/\s+/g)[0];
  }

  if (options.highlight) {
    highlighted =
      options.highlight(token.content, langName) || escapeHtml(token.content);
  } else {
    highlighted = escapeHtml(token.content);
  }

  highlighted = highlighted.replace(/"@@(.*)@@"/g, function(
    _match,
    p1,
    _offset,
    _string
  ) {
    return `<a href="#${p1.replace(/[_]/g, "-")}">${p1}</a>`;
  });
  highlighted = highlighted.replace(
    /`(.*)`/g,
    '<span class="token condition">$1</span>'
  );

  highlighted = highlighted.replace(
    /<span\s+class="token\s+string">\s*"~~(.*)~~"\s*<\/span>/g,
    function(_match, p1, _offset, _string) {
      return `<span class='token string'><a href='#${p1.replace(
        /[_]/g,
        "-"
      )}'>"${p1}"</a></span>`;
    }
  );

  if (highlighted.indexOf("<pre") === 0) {
    return highlighted + "\n";
  }

  // If language exists, inject class gently, without modifying original token.
  // May be, one day we will add .clone() for token and simplify this part, but
  // now we prefer to keep things local.
  if (info) {
    i = token.attrIndex("class");
    tmpAttrs = token.attrs ? token.attrs.slice() : [];

    if (i < 0) {
      tmpAttrs.push(["class", options.langPrefix + langName]);
    } else {
      tmpAttrs[i][1] += " " + options.langPrefix + langName;
    }

    // Fake token just to render attributes
    tmpToken = {
      attrs: tmpAttrs
    };

    return (
      "<pre><code" +
      slf.renderAttrs(tmpToken) +
      ">" +
      highlighted +
      "</code></pre>\n"
    );
  }

  return (
    "<pre><code" +
    slf.renderAttrs(token) +
    ">" +
    highlighted +
    "</code></pre>\n"
  );
};
