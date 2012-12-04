require 'yaml'
require 'trollop'

class Detrello

	def initialize(config)
		@config = YAML.load_file(config)
		puts @config.inspect
	end

end

opts = Trollop::options do
	opt :config, "Config file name", :type => :string, :required => true
end

detrello = Detrello.new(opts[:config])