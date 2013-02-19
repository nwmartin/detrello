detrello
========

Gets content out of Trello. It's specifically designed to dump it into the Confluence wiki markup syntax, because hey, that's
what I deal with weekly. If anyone actually needs this expanded on let me know and I can genericize it. This will work against
private boards as we're using ruby-trello's oauth provider.

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

--board-tag : specify a html header tag to size the Board name header
--list-tag : specify a html header tag to size the List name header(s)
--bullet-list : use to output cards in a bulleted list