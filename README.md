detrello
========

Gets content out of Trello. It's specifically designed to dump it into the Confluence wiki markup syntax, because hey, that's
what I deal with weekly. If anyone actually needs this expanded on let me know and I can genericize it. This will work against
private boards as we're using ruby-trello's oauth provider.

Setup on Windows
-----

	If Ruby is not installed: install Ruby (http://rubyinstaller.org/downloads/)(tested with Ruby 1.9.3-p545)
		Confirm that Ruby is in your PATH
	If Bundle is not installed: install bundler (http://bundler.io/)
		Bundler is a gem used to track all the specific versions of a gems associated with a project
	Continue with the rest of setup

Setup
-----

	bundle install
	cp secret.yml.example secret.yml

Now follow the instructions in secret.yml.

Usage
-----

	ruby detrello.rb --config secret.yml --output output --board BOARD_ID 

You can snag the board id from the board url. It's the guid at the end.

Optional Style Switches
-----------------------

--board-tag : specify a html header tag to change the size the Board name header

--list-tag : specify a html header tag to change the size the List name header(s)

--bullet-list : use to add bullets to card list output
