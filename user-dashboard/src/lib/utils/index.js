export function update(state, payload) {
  for (const key in payload) {
    if (Object.prototype.hasOwnProperty.call(payload, key)) {
      state[key] = payload[key];
    }
  }
}
