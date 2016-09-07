require 'test/unit'
require 'test_utils'
require 'nokogiri'
require 'questiongenerator/questionxmldata'
require 'questiongenerator/question'

class TestQuestionXMLData < Test::Unit::TestCase

  def setup
    TestUtils.create_test_dir
    @xml_data = QuestionGenerator::QuestionXMLData.new(TestUtils::GENERATE_QUESTION_FILES_DIR)
  end

  def teardown
    TestUtils.remove_test_dir
  end

  # Tests the write_question_data_xml method with standard question data.
  def test_write_question_data_xml
    questions = [
      QuestionGenerator::Question.new("test1.midi", QuestionGenerator::Chord.new(:c, :maj, :root_pos), [ 60, 64, 67 ]),
      QuestionGenerator::Question.new("test2.midi", QuestionGenerator::Chord.new(:d, :min_maj_seventh, :first_inv), [ 65, 69, 73, 74 ]),
      QuestionGenerator::Question.new("test3.midi", QuestionGenerator::Chord.new(:g_sharp_a_flat, :maj, :root_pos), [ 68, 72, 75 ]),
      QuestionGenerator::Question.new("test4.midi", QuestionGenerator::Chord.new(:f, :dom_seventh, :third_inv), [ 75, 77, 81, 84 ])
    ]

    for question in questions
      @xml_data.add_question(question)
    end

    @xml_data.write_question_data_xml
    generated_xml = File.open("#{TestUtils::GENERATE_QUESTION_FILES_DIR}/question_data.xml") { |file| Nokogiri::XML(file) }
    xml_questions = generated_xml.xpath("/questions/question")

    assert_equal("test1.midi", xml_questions[0].xpath("questionMidiFileName").text)
    assert_equal("C", xml_questions[0].xpath("answer/chordRoot").text)
    assert_equal("Major", xml_questions[0].xpath("answer/chordQuality").text)
    assert_equal("Root Position", xml_questions[0].xpath("answer/chordInversion").text)
    assert_equal([ 60, 64, 67 ], xml_questions[0].xpath("midiNotes").text.split.map { |note| note.to_i })
    assert_equal("test2.midi", xml_questions[1].xpath("questionMidiFileName").text)
    assert_equal("D", xml_questions[1].xpath("answer/chordRoot").text)
    assert_equal("Minor Major Seventh", xml_questions[1].xpath("answer/chordQuality").text)
    assert_equal("First Inversion", xml_questions[1].xpath("answer/chordInversion").text)
    assert_equal([ 65, 69, 73, 74 ], xml_questions[1].xpath("midiNotes").text.split.map { |note| note.to_i })
    assert_equal("test3.midi", xml_questions[2].xpath("questionMidiFileName").text)
    assert_equal("G#/Ab", xml_questions[2].xpath("answer/chordRoot").text)
    assert_equal("Major", xml_questions[2].xpath("answer/chordQuality").text)
    assert_equal("Root Position", xml_questions[2].xpath("answer/chordInversion").text)
    assert_equal([ 68, 72, 75 ], xml_questions[2].xpath("midiNotes").text.split.map { |note| note.to_i })
    assert_equal("test4.midi", xml_questions[3].xpath("questionMidiFileName").text)
    assert_equal("F", xml_questions[3].xpath("answer/chordRoot").text)
    assert_equal("Dominant Seventh", xml_questions[3].xpath("answer/chordQuality").text)
    assert_equal("Third Inversion", xml_questions[3].xpath("answer/chordInversion").text)
    assert_equal([ 75, 77, 81, 84 ], xml_questions[3].xpath("midiNotes").text.split.map { |note| note.to_i })
  end

end
