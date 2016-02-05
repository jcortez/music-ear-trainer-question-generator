# Takes care of the process of generating all necessary files.

require 'questiongenerator/midifilegenerator'

module QuestionGenerator
  class QuestionDataGenerator

    def initialize(dir_to_generate_files)
      @midi_file_generator = MIDIFileGenerator.new(dir_to_generate_files)
    end

    def generate_question_files
      @midi_file_generator.generate_all_midi_files
    end

  end
end
