# Parses the command line options given to the question generator.

require 'optparse'

module QuestionGenerator
  class CommandLineOptions
    # The default directory to generate all of the appropriate files in is the
    # current directory.
    DEFAULT_GENERATE_DIR = "."
    attr_reader :dir_to_generate_files

    def initialize
      @dir_to_generate_files = DEFAULT_GENERATE_DIR
    end
 
    # Parses the command line options given to the question generator.
    def parse(argv)
      OptionParser.new do |opts|
        opts.banner = "Usage: questiongenerator [options]"
        opts.on("-h", "prints this help message") do
          puts opts
        end
        opts.on("-d DIRECTORY", "directory to generate question files in (default will be the current directory)") do |dir|
          @dir_to_generate_files = dir
        end
      end.parse!
    end
  end
end
