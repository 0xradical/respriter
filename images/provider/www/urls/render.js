const params = JSON.parse( document.scripts[0].text );

document.write('<h1><a href="/">URLs Provider</a></h1>');
document.write(`<h2>${params['course_name']}</h2>`);
document.write(`<iframe width="560" height="315" src="https://www.youtube.com/embed/${params['video']['id']}" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>`);
document.write("<h3>Description</h3>");
document.write(`<pre>${params['description']}</pre>`);
document.write("<h3>Classpert JSON</h3>");
document.write(`<pre>${JSON.stringify(params, null, 2)}</pre>`);
