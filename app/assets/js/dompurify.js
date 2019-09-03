import DOMPurify from 'dompurify';

let domPurify;

const JSDOM = require('jsdom').JSDOM;
const { window } = new JSDOM('<!DOCTYPE html>');

domPurify = DOMPurify(window);

export default domPurify;
