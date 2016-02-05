# Generates MIDI files for all permutations of chord characteristics for the ear
# trainer questions.

module QuestionGenerator
  class MIDIFileGenerator

    def initialize(dir_to_generate_files)
      @dir_to_generate_midi_files = dir_to_generate_files
    end

public
    def generate_all_midi_files
      puts "Dir to generate files: #{@dir_to_generate_midi_files}"
      puts "generating MIDI files"
    end

  end
end
