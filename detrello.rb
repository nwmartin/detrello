require 'yaml'
require 'trollop'
require 'trello'

class Detrello
	include Trello
	include Trello::Authorization

	def initialize(config, output)
		@config = YAML.load_file(config)
		@output = File.open(output,'w+')

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
			abort
		end

		@output.puts '<h1>' + board.name + "</h1>"
		@output.puts

		board.lists.each do |list|
			delist(list)
		end

	end

	def delist(list)
		@output.puts '<h2>' + list.name + "</h2>"
		@output.puts
		list.cards.each do |card|
			decard(card)
		end
		@output.puts
	end

	def decard(card)
		@output.puts card.name
	end

end

opts = Trollop::options do
	opt :config, "Config file name", :type => :string, :required => true
	opt :output, "Output file", :type => :string, :required => true
	opt :board, "Board id", :type => :string, :required => true
end

detrello = Detrello.new(opts[:config], opts[:output])
detrello.deboard(opts[:board])