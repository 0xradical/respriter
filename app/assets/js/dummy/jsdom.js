/* dummy jsdom for client-side */
function JSDOM() {
  return { window: window };
}
export { JSDOM as JSDOM };