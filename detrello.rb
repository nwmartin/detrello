require 'yaml'
require 'trollop'
require 'trello'

class Detrello
	include Trello
	include Trello::Authorization

	def initialize(config)
		@config = YAML.load_file(config)

		Trello::Authorization.const_set :AuthPolicy, OAuthPolicy
		OAuthPolicy.consumer_credential = OAuthCredential.new @config["key"], @config["secret"]
		OAuthPolicy.token = OAuthCredential.new @config["token"], nil
	end

	def deboard(board)
		begin
			board = Board.find(board)
		rescue Exception => e
			puts 'Board ' + board + ' is invalid. Try snagging the id from the board url.'
			abort
		end
		unless board.has_lists?
			puts 'Board ' + board + ' doesn\'t actually have any lists.'
		end

		board.lists.each do |list|
			delist(list)
		end

	end

	def delist(list)
		puts list.name
		list.cards.each do |card|
			decard(card)
		end
	end

	def decard(card)
		puts card.name
	end

end

opts = Trollop::options do
	opt :config, "Config file name", :type => :string, :required => true
	opt :board, "Board name", :type => :string, :required => true
end

detrello = Detrello.new(opts[:config])
puts detrello.deboard(opts[:board])