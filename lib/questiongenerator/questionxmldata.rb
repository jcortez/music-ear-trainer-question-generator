# Generates XML that stores information about the question data.

require 'nokogiri'

module QuestionGenerator
  class QuestionXMLData

    # Stores the mapping between chord root symbols and their full names that will
    # be written to the XML file.
    CHORD_ROOT_NAMES = { c: "C", c_sharp_d_flat: "C#/Db", d: "D", d_sharp_e_flat:
      "D#/Eb", e: "E", f: "F", f_sharp_g_flat: "F#/Gb", g: "G", g_sharp_a_flat:
      "G#/Ab", a: "A", a_sharp_b_flat: "A#/Bb", b_c_flat: "B/Cb" }
    # Stores the mapping between chord quality symbols and their full names that
    # will be written to the XML file.
    CHORD_QUALITY_NAMES = { maj: "Major", min: "Minor", dim: "Diminished", aug:
      "Augmented", dom_seventh: "Dominant Seventh", maj_seventh: "Major Seventh",
      min_seventh: "Minor Seventh", min_maj_seventh: "Minor Major Seventh",
      half_dim_seventh: "Half Diminished Seventh", dim_seventh: "Diminished Seventh",
      sus_2: "Sus 2", sus_4: "Sus 4" }
    # Stores the mapping between chord inversion symbols and their full names that
    # will be written to the XML file.
    CHORD_INVERSION_NAMES = { root_pos: "Root Position", first_inv: "First Inversion",
      second_inv: "Second Inversion", third_inv: "Third Inversion" }
    XML_FILE_NAME = "question_data.xml"
    private_constant :CHORD_ROOT_NAMES
    private_constant :CHORD_QUALITY_NAMES
    private_constant :CHORD_INVERSION_NAMES
    private_constant :XML_FILE_NAME

    def initialize(dir_to_generate_files = '.')
      @dir_to_generate_xml = dir_to_generate_files
      @questions = Array.new
    end

  public
    # Adds a question to be written to the XML file.
    def add_question(question)
      @questions << question
    end

    # Writes the question data XML to a file. The file will be saved to the
    # directory set earlier or the current directory if this was not set.
    def write_question_data_xml
      builder = Nokogiri::XML::Builder.new do |xml|
        xml.questions {
          @questions.each do |question|
            xml.question {
              xml.questionMidiFileName question.question_midi_filename
              xml.answer {
                xml.chordRoot CHORD_ROOT_NAMES[question.answer.chord_root]
                xml.chordQuality CHORD_QUALITY_NAMES[question.answer.chord_quality]
                xml.chordInversion CHORD_INVERSION_NAMES[question.answer.chord_inversion]
              }
              xml.midiNotes {
                question.midi_notes.each { |note| xml.note note }
              }
            }
          end
        }
      end

      File.open("#{@dir_to_generate_xml}/#{XML_FILE_NAME}", 'w') { |file| file.print(builder.to_xml) }
    end

  end
end
