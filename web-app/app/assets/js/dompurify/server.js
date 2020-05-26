import dp from "dompurify";

const JSDOM = require("jsdom").JSDOM;
const { window } = new JSDOM("<!DOCTYPE html>");

const DOMPurify = dp(window);

export default DOMPurify;
