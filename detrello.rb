require 'yaml'
require 'trollop'
require 'trello'
require 'pry'

class Detrello
	include Trello
	include Trello::Authorization

	def initialize(config, output, board_tag, list_tag, bullet_list)
		begin
			@config = YAML.load_file(config)
		rescue Exception => e
			puts 'Config file does not exist!'
			puts e.message
			abort
		end
		@output = File.open(output,'w+')

		@board_tag = board_tag.downcase
		@list_tag = list_tag.downcase
		@bullet_list = bullet_list

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

		# Validate list tag input or return defaults
		if (@board_tag =~ /\Ah[1-6]{1}\Z/)
			@output.puts "<#@board_tag>" + board.name + "</#@board_tag>"
		else
			@output.puts '<h1>' + board.name + "</h1>"
		end
		
		@output.puts

		board.lists.each do |list|
			delist(list)
		end

	end

	def delist(list)
		
		# Validate list tag input or return defaults
		if (@list_tag =~ /\Ah[1-6]{1}\Z/)
			@output.puts "<#@list_tag>" + list.name + "</#@list_tag>"
		else
			@output.puts '<h2>' + list.name + "</h2>"
		end

		if @bullet_list
			
			@output.puts '<ul>'

			list.cards.each do |card|
				decard_with_bullets(card)
			end

			@output.puts "</ul>"
		
		else
			@output.puts
		
			list.cards.each do |card|
				decard(card)
			end
			
			@output.puts
		end

	end

	def decard(card)
		@output.puts card.name + '<br/>'
	end

	def decard_with_bullets(card)
		@output.puts '<li>' + card.name + "</li>"
	end


end

opts = Trollop::options do
	opt :config, "Config file name", :type => :string, :default => 'secret.yml'
	opt :output, "Output file", :type => :string, :default => 'output.html'
	opt :board, "Board id", :type => :string, :required => true
	opt :board_tag, "Board header HTML tag", :type => :string, :default => 'h1'
	opt :list_tag, "List header HTML tag", :type => :string, :default => 'h2'
	opt :bullet_list, "Add bullets to card output"
end

detrello = Detrello.new(opts[:config], opts[:output], opts[:board_tag], 
	opts[:list_tag], opts[:bullet_list])
detrello.deboard(opts[:board])
