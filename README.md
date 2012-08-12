Gilt JSON API example
=====================
This is an example JSON API that mimics what might power an app like gilt.com. Since Gilt doesn't have an actual API, it includes a HTML scraper that consumes Gilt's RSS feed.

Getting Started
---------------
Get a [Gilt API key](https://dev.gilt.com/user/register)

Get your environment on, and create and seed your database

    bundle && rake

`rake` could take some time; it downloads attributes and images for
every product currently on the site. 
    
Remember to move the image files to a location that is publicly
accessible to your webserver; this location is only accessible on the
API's address/port.

Start the server

    rackup

Warnings
--------
This software comes without guarantee of anything whatsoever. Scraped
data and images are forever property of Gilt, Inc at www.gilt.com. 

Be sure to show your appreciation by buying yourself some shoes, a scarf
or a new blazer; you could use a little zhuzsh. 

License
-------
MIT
