# Takes care of the process of generating all necessary files.

require 'questiongenerator/midifilegenerator'
require 'questiongenerator/questionxmldata'

module QuestionGenerator
  class QuestionDataGenerator

    def initialize(dir_to_generate_files)
      @question_xml_data = QuestionXMLData.new(dir_to_generate_files)
      @midi_file_generator = MIDIFileGenerator.new(dir_to_generate_files, @question_xml_data)
    end

    def generate_question_files
      @midi_file_generator.generate_all_midi_files
      @question_xml_data.write_question_data_xml
    end

  end
end
