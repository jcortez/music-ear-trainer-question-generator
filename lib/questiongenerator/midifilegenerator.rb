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
    # Stores the number of times you have to rotate a chord to get an inversion.
    INVERSION_ROTATIONS = { root_pos: 0, first_inv: 1, second_inv: 2, third_inv: 3 }
    # The MIDI notes for the C root position chords of the specified qualities.
    C_ROOT_POS_CHORDS = { maj: [ 60, 64, 67 ], min: [ 60, 63, 67 ],
      dim: [ 60, 63, 66 ], aug: [ 60, 64, 68 ], dom_seventh: [ 60, 64, 67, 70 ],
      maj_seventh: [ 60, 64, 67, 71 ], min_seventh: [ 60, 63, 67, 70 ],
      min_maj_seventh: [ 60, 63, 67, 71 ], half_dim_seventh: [ 60, 63, 66, 70 ],
      dim_seventh: [ 60, 63, 66, 69 ], sus_2: [ 60, 62, 67 ], sus_4: [ 60, 65, 67 ] }
    private_constant :MIDI_FILE_BPM
    private_constant :MIDI_FILE_VOLUME
    private_constant :MIDI_FILE_VELOCITY
    private_constant :CHORD_ROOTS
    private_constant :CHORD_QUALITIES
    private_constant :CHORD_INVERSIONS
    private_constant :NOTE_HALF_STEPS_ABOVE_C
    private_constant :INVERSION_ROTATIONS
    private_constant :C_ROOT_POS_CHORDS

    def initialize(dir_to_generate_files = '.')
      @dir_to_generate_midi_files = dir_to_generate_files
    end

  public
    # Generates all MIDI files for questions.
    def generate_all_midi_files #TODO: write tests for this method
      midi_file_id = 0
      for root in CHORD_ROOTS
        for quality in CHORD_QUALITIES
          for inversion in CHORD_INVERSIONS #TODO: only do third inversion chords for seventh chords.
            chord_notes = C_ROOT_POS_CHORDS[quality]
            chord_notes = transpose_chord_notes(chord_notes, root)
            chord_notes = generate_chord_inversion(chord_notes, inversion)
            midi_sequence = generate_chord_sequence(midi_file_id, chord_notes)
            write_sequence_to_file(midi_file_id, midi_sequence)
            puts "#{midi_file_id}.mid: #{root} #{quality} #{inversion}" #TODO: write data to XML using QuestionXMLData object
            midi_file_id += 1
          end
        end
      end

    end

  private
    # Generates a MIDI::Sequence from the given array of MIDI notes. The Sequence
    # will play all notes simultaneously (as a chord).
    def generate_chord_sequence(midi_file_id, chord_notes)
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
      chord_notes.each { |note| track.events << MIDI::NoteOn.new(0, note, MIDI_FILE_VELOCITY, 0) }
      chord_notes.each { |note| track.events << MIDI::NoteOff.new(0, note, MIDI_FILE_VELOCITY, note_length) }

      sequence.tracks << track
      sequence
    end

    # Writes a MIDI::Sequence to a MIDI file.
    def write_sequence_to_file(midi_file_id, sequence)
      File.open("#{@dir_to_generate_midi_files}/#{midi_file_id}.mid", 'wb') { |file| sequence.write(file) }
    end

    # Transposes the chord notes to be a new chord at the new root specified. A
    # new array is returned as a result.
    def transpose_chord_notes(chord_notes, new_root)
      chord_notes.map { |note| note + NOTE_HALF_STEPS_ABOVE_C[new_root] }
    end

    # Rotates the notes of the root position chord specified the appropriate
    # amount of times to generate the chord inversion. This is done by
    # transposing the appropriate notes up an octave. A new array is returned as
    # a result.
    def generate_chord_inversion(chord_notes, inversion)
      chord_notes_inversion = Array.new(chord_notes)
      num_of_rotations = INVERSION_ROTATIONS[inversion]
      return chord_notes_inversion if num_of_rotations <= 0

      for i in 0..num_of_rotations-1
        chord_notes_inversion[i] += 12
      end

      chord_notes_inversion
    end
  end
end
