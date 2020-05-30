var req = require.context('../images', true, /^(.*\.(png|jpe?g|gif$))[^.]*$/im);
req.keys().forEach( function(key) {
  var icon = req(key);
});

var req = require.context('../svg', true, /^(.*\.(svg$))[^.]*$/im);
req.keys().forEach( function(key) {
  var icon = req(key);
});
