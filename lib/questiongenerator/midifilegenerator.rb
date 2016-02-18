# Generates MIDI files for all permutations of chord characteristics for the ear
# trainer questions.

require 'midilib/sequence'
require 'midilib/consts'

module QuestionGenerator
  class MIDIFileGenerator
    MIDI_FILE_BPM = 170
    MIDI_FILE_VOLUME = 127
    MIDI_FILE_VELOCITY = 127
    # Ruby symbols for the chord characteristics.
    CHORD_ROOTS = [ :c, :c_sharp_d_flat, :d, :d_sharp_e_flat, :e, :f,
      :f_sharp_g_flat, :g, :g_sharp_a_flat, :a, :a_sharp_b_flat, :b_c_flat ]
    CHORD_QUALITIES = [ :maj, :min,  :dim, :aug, :dom_seventh, :maj_seventh,
      :min_seventh, :min_maj_seventh, :half_dim_seventh, :dim_seventh, :sus_2,
      :sus_4 ]
    CHORD_INVERSIONS = [ :root_pos, :first_inv, :second_inv, :third_inv ]
    # Stores the number of half steps above C that a note is at.
    NOTE_HALF_STEPS_ABOVE_C = { c: 0, c_sharp_d_flat: 1, d: 2, d_sharp_e_flat: 3,
      e: 4, f: 5, f_sharp_g_flat: 6, g: 7, g_sharp_a_flat: 8, a: 9,
      a_sharp_b_flat: 10, b_c_flat: 11 }
    private_constant :MIDI_FILE_BPM
    private_constant :MIDI_FILE_VOLUME
    private_constant :MIDI_FILE_VELOCITY
    private_constant :CHORD_ROOTS
    private_constant :CHORD_QUALITIES
    private_constant :CHORD_INVERSIONS
    private_constant :NOTE_HALF_STEPS_ABOVE_C
    #TODO: add constants for:
    # - MIDI sequeces for all C chords (major,minor, etc.) for each chord inversion

    def initialize(dir_to_generate_files = '.')
      @dir_to_generate_midi_files = dir_to_generate_files
    end

  public
    # Generates all MIDI files for questions.
    def generate_all_midi_files
      midi_file_id = 0
      for root in CHORD_ROOTS
        for quality in CHORD_QUALITIES
          for inversion in CHORD_INVERSIONS
            #TODO: finish implementing
            #sequence = get notes for quality, inversion (will be C root) and generate sequence from it using offset NOTE_HALF_STEPS_ABOVE_C[root]
            #write sequence to midi file
            #write midi_file_id, root, quality, inversion to xml file as question (call QuestionXMLData object to do this)
            #midi_file_id++
          end
        end
      end

    end

  private
    # Generates a MIDI::Sequence from the given array of MIDI notes transposed up
    # the specified amount of half steps. The Sequence will play all notes
    # simultaniously (as a chord).
    def generate_sequence(midi_file_id, notes, half_steps_up = 0)
      sequence = MIDI::Sequence.new
      track = MIDI::Track.new(sequence)
      track.events << MIDI::Tempo.new(MIDI::Tempo.bpm_to_mpq(MIDI_FILE_BPM))
      track.events << MIDI::MetaEvent.new(MIDI::META_SEQ_NAME, "#{midi_file_id}")
      sequence.tracks << track

      track = MIDI::Track.new(sequence)
      track.name = 'Piano'
      track.instrument = MIDI::GM_PATCH_NAMES[0]
      track.events << MIDI::Controller.new(0, MIDI::CC_VOLUME, MIDI_FILE_VOLUME)

      note_length = sequence.note_to_delta('whole')
      track.events << MIDI::ProgramChange.new(0,1,0)
      notes.each { |note| track.events << MIDI::NoteOn.new(0, note + half_steps_up, MIDI_FILE_VELOCITY, 0) }
      notes.each { |note| track.events << MIDI::NoteOff.new(0, note + half_steps_up, MIDI_FILE_VELOCITY, note_length) }

      sequence.tracks << track
      sequence
    end

    # Writes a MIDI::Sequence to a MIDI file.
    def write_sequence_to_file(midi_file_id, sequence)
      File.open("#{@dir_to_generate_midi_files}/#{midi_file_id}.mid", 'wb') { |file| sequence.write(file) }
    end
  end
end
