var req = require.context('../svg', true, /^(.*\.(svg$))[^.]*$/im);
req.keys().forEach( function(key) {
  var icon = req(key);
});

