const cors = require("cors");

const corsOptions = {};
if (process.env.SPRITE_CORS_ORIGIN) {
  corsOptions.origin = process.env.SPRITE_CORS_ORIGIN;
}

module.exports = cors(corsOptions);
