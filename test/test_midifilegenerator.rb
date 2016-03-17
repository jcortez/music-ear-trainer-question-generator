require 'test/unit'
require 'test_utils'
require 'nokogiri'
require 'questiongenerator/questionxmldata'
require 'questiongenerator/midifilegenerator'
require 'midilib/io/seqreader'

class TestMidiFileGenerator < Test::Unit::TestCase
  NUM_OF_MIDI_FILES_GENERATED = 504
  private_constant :NUM_OF_MIDI_FILES_GENERATED    

public
  def setup
    TestUtils.create_test_dir
    @xml_data = QuestionGenerator::QuestionXMLData.new(TestUtils::GENERATE_QUESTION_FILES_DIR)
    @midi_file_generator = QuestionGenerator::MIDIFileGenerator.new(TestUtils::GENERATE_QUESTION_FILES_DIR, @xml_data)
  end

  def teardown
    TestUtils.remove_test_dir
  end

  # Tests the generate_all_midi_files method.
  def test_generate_all_midi_files
    @midi_file_generator.generate_all_midi_files
    @xml_data.write_question_data_xml

    # Check that the correct number of MIDI files and XML entries are generated.
    generated_midi_files = Dir.glob("#{TestUtils::GENERATE_QUESTION_FILES_DIR}/*.mid")
    assert_equal(NUM_OF_MIDI_FILES_GENERATED, generated_midi_files.length)

    generated_xml = File.open("#{TestUtils::GENERATE_QUESTION_FILES_DIR}/question_data.xml") { |file| Nokogiri::XML(file) }
    xml_questions = generated_xml.xpath("/questions/question")
    assert_equal(NUM_OF_MIDI_FILES_GENERATED, xml_questions.length)

    # Check that several MIDI files are generated correctly.
    check_midi_file_generated_correctly(xml_questions, "E", "Major Seventh", "Root Position", [64, 68, 71, 75, 64, 68, 71, 75])
    check_midi_file_generated_correctly(xml_questions, "B/Cb", "Minor", "First Inversion", [74, 78, 83, 74, 78, 83])
    check_midi_file_generated_correctly(xml_questions, "C#/Db", "Sus 4", "Second Inversion", [68, 73, 78, 68, 73, 78])
    check_midi_file_generated_correctly(xml_questions, "G#/Ab", "Half Diminished Seventh", "Third Inversion", [78, 80, 83, 86, 78, 80, 83, 86])
  end

  # Tests that the generate_all_midi_files method generates third inversion
  # chords only for the appropriate chords.
  def test_generate_all_midi_files_third_inversion
    @midi_file_generator.generate_all_midi_files
    @xml_data.write_question_data_xml
    generated_xml = File.open("#{TestUtils::GENERATE_QUESTION_FILES_DIR}/question_data.xml") { |file| Nokogiri::XML(file) }
    xml_questions = generated_xml.xpath("/questions/question")

    # This third inversion chord should be generated.
    check_midi_file_generated_correctly(xml_questions, "G", "Major Seventh", "Third Inversion", [78, 79, 83, 86, 78, 79, 83, 86])
    # This third inversion chord should not be generated.
    chord = xml_questions.xpath("answer[chordRoot/text()='F' and chordQuality/text()='Diminished' and chordInversion/text()='Third Inversion']")
    assert_equal(0, chord.length)
  end

private
  # Read a MIDI file using data from the XML file and check that it generated
  # the notes correctly for a specific chord.
  def check_midi_file_generated_correctly(xml_questions, chord_root, chord_quality, chord_inversion, correct_midi_notes)
    midi_file_name = xml_questions.at_xpath("answer[chordRoot/text()='#{chord_root}' and chordQuality/text()='#{chord_quality}' and chordInversion/text()='#{chord_inversion}']/../questionMidiFileName").text
    assert_equal(false, midi_file_name.strip.empty?)
    assert(File.exist?("#{TestUtils::GENERATE_QUESTION_FILES_DIR}/#{midi_file_name}"))

    midi_sequence = MIDI::Sequence.new
    File.open("#{TestUtils::GENERATE_QUESTION_FILES_DIR}/#{midi_file_name}", 'rb') { |file| midi_sequence.read(file) }
    generated_midi_notes = Array.new
    midi_sequence.each do |track|
      track.each do |event|
        if MIDI::NoteEvent === event
          generated_midi_notes << event.note
        end
      end
    end

    assert_equal(correct_midi_notes, generated_midi_notes)
  end

end
