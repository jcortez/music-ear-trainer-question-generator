# Generates XML that stores information about the question data.

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
    private_constant :CHORD_ROOT_NAMES
    private_constant :CHORD_QUALITY_NAMES
    private_constant :CHORD_INVERSION_NAMES


  end
end
