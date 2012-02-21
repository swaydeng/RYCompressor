RYCompressor
=======

A simple but easy way to compress JavaScript and CSS files, it is written in ruby based on [YUI Compressor](http://developer.yahoo.com/yui/compressor/).

<https://github.com/swaydeng/RYCompressor>

Dependencies
-------

The following environments are required:

* [Java](http://java.sun.com/) (requires Java >= 1.4)
* [Ruby](http://www.ruby-lang.org/) (requires Ruby >= 1.9.x)

HowTo
-------

To compress one or more files:

    $ ./rycompressor.rb some-file.js some-other-file.css

It will generate two files(`some-file-min.js`, `some-other-file-min.css`) in the same directory.

To compress all JavaScript and CSS files in a directory:

	$ ./rycompressor.rb some/dir some/other/dir

It will find files in the directory and then compress them. 

license
-------

> License: none (public domain)
