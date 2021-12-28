### Turning GIFs into Image2ASCII web animations
[Click to see a live example](https://michaelkofron.github.io/image2ascii/MakingWebAnimations/)

Since Image2ASCII returns the ASCII in the form of a string, we can use it to turn animated GIFs into web animations by parsing a GIF, adding the ASCII strings into a JSON file, and looping over them with setInterval(). 

Prerequisites
----------

Requires ImageMagick which can be downloaded [here](https://imagemagick.org/script/download.php)

Requires the Image2ASCII ruby gem

`$ gem install image2ascii`

Usage
----------

Make sure you have installed the prerequisites ^^^

Have an understanding of [how Image2ASCII works](https://github.com/michaelkofron/image2ascii#image2ascii)

Download this directory

Replace image.gif with a gif of your choosing (name it image.gif or else change the run.rb file to match)

Run the "run.rb" Ruby file (edit this file to customize your ascii art)

You will now have a file called "steps.json" in the directory which can be used along with javascript's fetch to loop over each frame of the ascii animation. To see a very simple example you can look at the index.html file. 

To run the index.html file yourself and see it in action you will need to run an http-server (or else fetch won't be able to grab the JSON file)

`npm install http-server`

then in the directory run: 

`http-server`

