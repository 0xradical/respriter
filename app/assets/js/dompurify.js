import DOMPurify from 'dompurify';
import { isNode } from 'browser-or-node';

let domPurify;

if(isNode) {
  const JSDOM = require('jsdom').JSDOM;
  const { window } = new JSDOM('<!DOCTYPE html>');
  domPurify = DOMPurify(window);
} else {
  domPurify = DOMPurify(window);
}

export default domPurify;
