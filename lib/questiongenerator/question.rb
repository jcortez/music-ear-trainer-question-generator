module QuestionGenerator
  # Represents information for a chord ear trainer question.
  class Question
    attr_accessor :question_midi_filename, :answer, :midi_notes

    def initialize(filename, answer, notes)
      @question_midi_filename = filename
      @answer = answer
      @midi_notes = notes
    end

  end

  # Represents chord information.
  class Chord
    attr_accessor :chord_root, :chord_quality, :chord_inversion

    def initialize(root, quality, inversion)
      @chord_root = root
      @chord_quality = quality
      @chord_inversion = inversion
    end

  end
end
