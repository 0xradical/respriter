const params = JSON.parse( document.scripts[0].text );

document.write('<h1><a href="/">Sitemap\'s Provider</a></h1>');
document.write(`<h2>${params['course_name']}</h2>`);

if ( params['video'] ) {
  if ( params['video']['type'] === 'youtube' ) {
    document.write(`<iframe width="560" height="315" src="https://www.youtube.com/embed/${params['video']['id']}" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>`);
  }

  if ( params['video']['type'] === 'vimeo' ) {
    document.write(`<iframe src="https://player.vimeo.com/video/${params['video']['id']}" width="640" height="303" frameborder="0" allow="autoplay; fullscreen" allowfullscreen></iframe>`)
  }
}

document.write("<h3>Description</h3>");

if ( params['description'] ){
  document.write(`<pre>${params['description']}</pre>`);
} else {
  document.write(`<pre>No Description</pre>`);
}

document.write("<h3>Classpert JSON</h3>");
document.write(`<pre>${JSON.stringify(params, null, 2)}</pre>`);
